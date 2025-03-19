import pdb

class Config(pdb.DefaultConfig):

    prompt = '(Pdb++) ==>'
    sticky_by_default = True

    editor = 'micro'
    use_terminal256formatter = False

    def __init__(self):
        import readline
        import atexit
        import os

        # readline.parse_and_bind('set convert-meta on')
        # readline.parse_and_bind('Meta-/: complete')

        # loading history file
        history_path = os.path.expanduser("~/.history_pdbpp")
        if os.path.exists(history_path):
            readline.read_history_file(history_path)

        # saving history file handler
        def save_history():
            readline.set_history_length(10000)
            readline.write_history_file(history_path)

        atexit.register(save_history)

    def setup(self, pdbpp):
        # make 'l' an alias to 'longlist'
        pdb_class = pdbpp.__class__
        pdb_class.do_l = pdb_class.do_longlist
        pdb_class.do_st = pdb_class.do_sticky
