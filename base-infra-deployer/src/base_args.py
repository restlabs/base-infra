from __version__ import __version__
import argparse



class Base(argparse.ArgumentParser):
    """Base arguments"""
    def __init__(self, *args, **kwargs):
        super.__init__(*args, **kwargs)

        self.add_argument(
            '-v',
            '--version',
            action='version',
            help='base infra deployer',
            version=__version__
        )