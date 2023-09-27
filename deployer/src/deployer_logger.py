import logging


def logger() -> logging.Logger:
    """
    creates a logger
    """
    retval = logging.getLogger(__name__)

    if not retval.hasHandlers():
        retval.setLevel(logging.INFO)
        log_formatter = logging.Formatter(
            datefmt='%Y-%m-%d %H:%M:%S',
            fmt='%(asctime)s [%(levelname)s] - %(message)s'
        )
        stream_handler = logging.StreamHandler()
        stream_handler.setFormatter(log_formatter)
        retval.addHandler(stream_handler)

    return retval


logger = logger()
