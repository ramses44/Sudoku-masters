from flask import Flask, request
import click
import subprocess
from random import shuffle
from threading import Thread, Condition, Lock

GENERATION_TIMEOUT = 15

app = Flask(__name__)
path_to_generator: str
threads_available: int

cached: dict[tuple[int, str], tuple[int, list[str]]] = {  # {(size, difficulty): (required_to_pregen, lst_of_sudoku)}
    (4, 'easy'): (10, []),
    (4, 'medium'): (10, []),
    (4, 'hard'): (10, []),
    (9, 'easy'): (10, []),
    (9, 'medium'): (50, []),
    (9, 'hard'): (10, []),
    (16, 'easy'): (5, []),
    (16, 'medium'): (0, []),
    (16, 'hard'): (0, [])
}
cache_lock = Lock()
thread_lock = Lock()
bg_condvar = Condition(lock=None)


def background_generator():
    while True:
        keys = list(cached.keys())
        shuffle(keys)
        for size, dif in keys:
            required, genned = cached[(size, dif)]
            if required > len(genned):
                try:
                    with thread_lock:
                        pass
                    result = subprocess.run([path_to_generator, '--size', str(size), '--difficulty', dif,
                                             '--threads', str(threads_available // 2)],
                                            stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=GENERATION_TIMEOUT)
                    result.check_returncode()
                    with cache_lock:
                        genned.append(result.stdout.decode('utf-8'))

                    print(f'Sudoku {size}x{size} {dif} was pregenerated')
                except (subprocess.TimeoutExpired, subprocess.CalledProcessError):
                    pass
                break
        else:
            with bg_condvar:
                bg_condvar.wait()


@app.route('/generate', methods=['GET'])
def generate():
    size = request.args.get('size')
    dif = request.args.get('difficulty')

    if size is None or dif is None:
        return 'Necessary parameters was not provided!', 400

    try:
        size = int(size)
    except ValueError:
        return 'Invalid size parameter!', 400

    dif = dif.lower()

    with cache_lock:
        if (size, dif) not in cached:
            return 'Invalid parameters!', 400

        genned = cached[(size, dif)][1]
        if len(genned) != 0:
            with bg_condvar:
                bg_condvar.notify()
            return genned.pop(), 200

    try:
        with thread_lock:
            result = subprocess.run([path_to_generator, '--size', str(size),
                                     '--difficulty', dif, '--threads', str(threads_available)],
                                    stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=GENERATION_TIMEOUT)
        result.check_returncode()
        return result.stdout, 200
    except (subprocess.TimeoutExpired, subprocess.CalledProcessError):
        return 'Server Error', 500


@click.command()
@click.option("--generator_path", type=str)
@click.option("--threads", type=int)
@click.option("--host", type=str)
@click.option("--port", type=int)
def main(generator_path, threads, host, port):
    global path_to_generator, threads_available

    if generator_path is None:
        raise AttributeError('Generator is not specified!')
    if threads is None or threads < 1:
        threads = 1
    if host is None:
        host = '0.0.0.0'
    if port is None:
        raise AttributeError('Port is not specified!')

    path_to_generator = generator_path
    threads_available = threads

    Thread(target=background_generator, daemon=True).start()

    app.run(host=host, port=port)


if __name__ == '__main__':
    main()
