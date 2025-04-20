
_generate_lean-lib-python_here() {
	cat << 'CZXWXcRMTo8EmM8i4d'

# https://stackoverflow.com/questions/44834/can-someone-explain-all-in-python

# https://bruxy.regnet.cz/programming/bash-python/workshop_bash-python-en.html
# https://www.geeksforgeeks.org/how-to-run-bash-script-in-python/
# https://softwareengineering.stackexchange.com/questions/207613/encoding-a-bash-script-for-use-in-python

# https://www.codementor.io/@arpitbhayani/personalize-your-python-prompt-13ts4kw6za

# https://kimsereylam.com/python/2020/02/07/improve-your-python-shell-with-pythonrc.html




#os.system("python --version")
#print (sys.version_info)



#os.system("ubiquitous_bash.sh _getAbsoluteFolder .")



# https://www.geeksforgeeks.org/how-to-pass-multiple-arguments-to-function/

#def _bin(currentArgumentsString):
#	os.system("ubiquitous_bash.sh _bin " + currentArgumentsString)

#_bin("_getAbsoluteFolder .")

#_bin("_scope .")

#_bin("_bash -i")



#def _bash():
#	os.system("ubiquitous_bash.sh _bin _bash -i ")

#def _bash():
#	os.system("$HOME/.ubcore/ubiquitous_bash/ubcore.sh _bash -i ")

#_bash()





########################################


# WARNING: Python API documentation suggests significant possibility of incompatibility (perhaps return object type) 'if sys.hexversion < 0x03060000' or 'if sys.hexversion < 0x03000000'.
# CAUTION: Python API version compatibility may or may not be strictly enforced, due to lack of known failures, and/or usual expectations of problems from the multiple ways of doing things.
# Apparently reasonable expectations confirmed by exhaustive research may be met if python version is at least >0x20710f0 and <0x30703f0 .
#import sys
#if sys.hexversion < 0x03060000:
# https://stackoverflow.com/questions/446052/how-can-i-check-for-python-version-in-a-program-that-uses-new-language-features
#	exit(1)


#_messagePlain_request( 'request: user please install...' )
def _messagePlain_request(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[0;35m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messagePlain_nominal( 'init: _function' )
def _messagePlain_nominal(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[0;36m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messagePlain_probe( '_messagePlain_probe ( \'_messagePlain_probe\' ) ' )
def _messagePlain_probe(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[0;34m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messagePlain_good( 'good: success' )
def _messagePlain_good(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[0;32m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messagePlain_warn( 'warn: workaround' )
def _messagePlain_warn(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[1;33m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messagePlain_bad( 'bad: fail: missing' )
def _messagePlain_bad(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[0;31m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messageNormal( '_function_sequence: Stop' )
def _messageNormal(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[1;32;46m\x02 ' + currentMessage + ' \x01\033[0m\x02' )

#_messageError( 'FAIL: unknown app failure' )
def _messageERROR(currentMessage = '', currentContext = '(python)'):
	print ( '\x01\033[0;35;47m\x02' + currentContext + '\x01\033[0m\x02' + '\x01\033[1;33;41m\x02 ' + currentMessage + ' \x01\033[0m\x02' )


#_messageNormal( '_function_sequence: Start' )

#_messagePlain_nominal( 'init: _function' )
#_messagePlain_request( 'request: user please install...' )
#_messagePlain_probe( '_messagePlain_probe ( \'_messagePlain_probe\' ) ' )

#_messagePlain_good( 'good: success' )
#_messagePlain_warn( 'warn: workaround' )
#_messagePlain_bad( 'bad: fail: missing' )

#_messageERROR( 'FAIL: unknown app failure' )

#_messageNormal( '_function_sequence: Stop' )







import sys
# https://stackoverflow.com/questions/446052/how-can-i-check-for-python-version-in-a-program-that-uses-new-language-features
#if sys.hexversion < 0x03060000:
#	exit(1)
import string
import subprocess
import os
# WARNING: Procedures exclusively relying on python code are NOT intended or expected to be robust. Instead use '_getScriptAbsoluteLocation' within 'ubiquitous_bash.sh' as able.
# WARNING: Whether '__file__' has similar characteristics to "$0" as used within 'ubiquitous_bash' in all relevant cases is NOT determined and is NOT to be relied upon.
# WARNING: Historically 'python' has NOT had the API stability, reliability, or portability of 'bash'.
# https://stackoverflow.com/questions/4934806/how-can-i-find-scripts-directory
# https://stackoverflow.com/questions/3503879/assign-output-of-os-system-to-a-variable-and-prevent-it-from-being-displayed-on
#currentPathCheck = subprocess.Popen(['/bin/bash', '--noprofile', '--norc', '-c', 'type -p ubiquitous_bash.sh'], stdout=subprocess.PIPE, universal_newlines=True)
#print(os.path.dirname(os.path.realpath(__file__)))
#print(sys.path[0])
#os.path.abspath(os.path.dirname(os.path.realpath(__file__))).rstrip('\n')
#if True:
#currentProc = subprocess.Popen(['/bin/bash', '-c', 'ubiquitous_bash.sh _getAbsoluteFolder ' + __file__], stdout=subprocess.PIPE, universal_newlines=True)
#currentProc = subprocess.Popen(['/bin/bash', '--noprofile', '--norc', '-c', 'ubiquitous_bash.sh _getAbsoluteFolder ' + __file__], stdout=subprocess.PIPE, universal_newlines=True)
#currentProc = subprocess.Popen(['ubiquitous_bash.sh', '_getAbsoluteFolder', __file__], stdout=subprocess.PIPE, universal_newlines=True)
def _getScriptAbsoluteFolder():
	currentPathCheck = subprocess.Popen(['/bin/bash', '-c', 'type -p ubiquitous_bash.sh'], stdout=subprocess.PIPE, universal_newlines=True)
	currentPathCheck.communicate()
	currentPathCheck.wait()
	if currentPathCheck.returncode == 0:
		currentProc = subprocess.Popen(['ubiquitous_bash.sh', '_getAbsoluteFolder', __file__], stdout=subprocess.PIPE, universal_newlines=True)
		(currentOut, currentErr) = currentProc.communicate()
		currentProc.wait()
		currentOut = currentOut.rstrip('\n')
		return(currentOut.rstrip('\n'))
	else:
		return(os.path.abspath(os.path.dirname(os.path.realpath(__file__))).rstrip('\n'))

#print(_getScriptAbsoluteFolder())










import sys
#if sys.hexversion < 0x03060000:
#	exit(1)
import string
import subprocess
import os
#
#_bash()
# WARNING: CAUTION: DANGER: Beware '_getScriptAbsoluteLocation' will NOT be set correctly!
#_bash(['-c', '_getScriptAbsoluteLocation'], True, os.path.expanduser("~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"))
#_bash("-c '_getScriptAbsoluteLocation'", True, os.path.expanduser("~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"))
#
#_bash(['-c', 'echo test', 'xyz'])
#print(_bash(['-c', 'echo test', 'xyz'], False))
#print(_bash(['-c', '_false'], False))
#print(_bash(['-c', '_false'], False)[1])
#
#_bash('-i')
#_bash("-c '/bin/echo true'")
#_bash("-c 'echo true'")
# https://stackoverflow.com/questions/38821586/one-line-to-check-if-string-or-list-then-convert-to-list-in-python
# https://stackoverflow.com/questions/23883394/detect-if-python-script-is-run-from-an-ipython-shell-or-run-from-the-command-li
#sys.argv[1]
#os.system("$HOME/.ubcore/ubiquitous_bash/ubcore.sh _bash -i ")
#currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
#print(['ubiquitous_bash.sh', '_bash'] + currentArguments)
# ATTENTION: WARNING: Enjoy this python code. The '_bash' and '_bin' function are quite possibly, even probably, and for actual reasons for every line of code being annoying, the worst python code that will ever be written by people. In plainer language, only mess with parts of this code for which you have stopped to fully understand exactly why every negation, if/else, return, print, etc, is in the exact order that it is.
def _bash(currentArguments = ['-i'], currentPrint = False, current_ubiquitous_bash = "ubiquitous_bash.sh", interactive=True):
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists(os.environ.get("scriptCall_bash_msw", "").replace('\\', '/')):
            current_ubiquitous_bash = os.environ.get("scriptCall_bash_msw", "").replace('\\', '/')
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists(os.environ.get("scriptAbsoluteLocation", "")):
            current_ubiquitous_bash = os.environ.get("scriptAbsoluteLocation", "")
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists(os.environ['HOME'] + "/.ubcore/ubiquitous_bash/ubcore.sh"):
            current_ubiquitous_bash = (os.environ['HOME'] + "/.ubcore/ubiquitous_bash/ubcore.sh")
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists("/cygdrive/c/core/infrastructure/ubiquitous_bash/ubcore.sh"):
            current_ubiquitous_bash = "/cygdrive/c/core/infrastructure/ubiquitous_bash/ubcore.sh"
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists("/cygdrive/c/core/infrastructure/ubiquitous_bash/lean.sh"):
            current_ubiquitous_bash = "/cygdrive/c/core/infrastructure/ubiquitous_bash/lean.sh"
    currentArguments = ['-i'] if currentArguments == '-i' else currentArguments
    if isinstance(currentArguments, str):
    # WARNING: Discouraged.
        if not ( ( currentArguments == '-i' ) or ( currentArguments == '' ) or ( interactive == True ) ):
            # ATTENTION: WARNING: Use of 'stdout=subprocess.PIPE' is NOT compatible with interactive shell!
            currentProc = subprocess.Popen(current_ubiquitous_bash + " _bash " + currentArguments, stdout=subprocess.PIPE, universal_newlines=True, shell=True)
            (currentOut, currentErr) = currentProc.communicate()
            currentProc.wait()
            currentOut = currentOut.rstrip('\n')
            if currentPrint == True:
                print(currentOut)
                return (currentOut), currentProc.returncode
        else:
            currentProc = subprocess.Popen(current_ubiquitous_bash + " _bash " + currentArguments, universal_newlines=True, shell=True)
            (currentOut, currentErr) = currentProc.communicate()
            currentProc.wait()
        return (currentOut), currentProc.returncode
    else:
        if not ( ( currentArguments == ['-i'] ) or ( currentArguments == [''] ) or ( interactive == True ) ):
            currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
            # ATTENTION: WARNING: Use of 'stdout=subprocess.PIPE' is NOT compatible with interactive shell!
            currentProc = subprocess.Popen([current_ubiquitous_bash, '_bash'] + currentArguments, stdout=subprocess.PIPE, universal_newlines=True)
            (currentOut, currentErr) = currentProc.communicate()
            currentProc.wait()
            currentOut = currentOut.rstrip('\n')
            if currentPrint == True:
                print(currentOut)
                return (currentOut), currentProc.returncode
        else:
            if ( currentArguments == [''] ): currentArguments = ['-i']
            currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
            currentProc = subprocess.Popen([current_ubiquitous_bash, '_bash'] + currentArguments, universal_newlines=True)
            (currentOut, currentErr) = currentProc.communicate()
            currentProc.wait()
        return (currentOut), currentProc.returncode





import sys
#if sys.hexversion < 0x03060000:
#	exit(1)
import string
import subprocess
import os
#
#_bin(['/bin/bash', '-i'])
#_bin(['_getScriptAbsoluteLocation'], True, os.path.expanduser("~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"))
#_bin(['_getScriptAbsoluteLocation'], True)
#_bin(['echo', 'test'], True, os.path.expanduser("~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"))
#print(_bin(['_false'], False, os.path.expanduser("~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"))[1])
#
#_bin('_true')
#_bin('_echo test')
#_bin('_bash')
#print( _bin('_false', False)[1] )
#_bin("_getScriptAbsoluteLocation", True, os.path.expanduser("~/core/infrastructure/ubiquitous_bash/ubiquitous_bash.sh"))
# ATTENTION: WARNING: Enjoy this python code. The '_bash' and '_bin' function are quite possibly, even probably, and for actual reasons for every line of code being annoying, the worst python code that will ever be written by people. In plainer language, only mess with parts of this code for which you have stopped to fully understand exactly why every negation, if/else, return, print, etc, is in the exact order that it is.
def _bin(currentArguments = [''], currentPrint = False, current_ubiquitous_bash = "ubiquitous_bash.sh", interactive=False):
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists(os.environ.get("scriptCall_bash_msw", "").replace('\\', '/')):
            current_ubiquitous_bash = os.environ.get("scriptCall_bash_msw", "").replace('\\', '/')
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists(os.environ.get("scriptAbsoluteLocation", "")):
            current_ubiquitous_bash = os.environ.get("scriptAbsoluteLocation", "")
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists(os.environ['HOME'] + "/.ubcore/ubiquitous_bash/ubcore.sh"):
            current_ubiquitous_bash = (os.environ['HOME'] + "/.ubcore/ubiquitous_bash/ubcore.sh")
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists("/cygdrive/c/core/infrastructure/ubiquitous_bash/ubcore.sh"):
            current_ubiquitous_bash = "/cygdrive/c/core/infrastructure/ubiquitous_bash/ubcore.sh"
    if current_ubiquitous_bash == "ubiquitous_bash.sh":
        if os.path.exists("/cygdrive/c/core/infrastructure/ubiquitous_bash/lean.sh"):
            current_ubiquitous_bash = "/cygdrive/c/core/infrastructure/ubiquitous_bash/lean.sh"
    # ATTENTION: Comment out next python line of code to test this code with an empty string.
    #./lean.py "_bin('', currentPrint=True)"
    currentArguments = [''] if currentArguments == '' else currentArguments
    if isinstance(currentArguments, str):
        # WARNING: Discouraged.
        if not ( ( ( currentArguments == '/bin/bash -i' ) or ( currentArguments == '/bin/bash' ) or ( currentArguments == '_bash' ) or ( currentArguments == '' ) ) or ( interactive == True ) ) :
            # ATTENTION: WARNING: Use of 'stdout=subprocess.PIPE' is NOT compatible with interactive shell!
            currentProc = subprocess.Popen(current_ubiquitous_bash + " _bin " + currentArguments, stdout=subprocess.PIPE, universal_newlines=True, shell=True)
            (currentOut, currentErr) = currentProc.communicate()
            currentProc.wait()
            currentOut = currentOut.rstrip('\n')
            if currentPrint == True:
                print(currentOut)
                return (currentOut), currentProc.returncode
        else:
            if ( currentArguments == '' ): currentArguments = '_bash'
            currentProc = subprocess.Popen(current_ubiquitous_bash + " _bin " + currentArguments, universal_newlines=True, shell=True)
            (currentOut, currentErr) = currentProc.communicate()
            currentProc.wait()
        return (currentOut), currentProc.returncode
    else:
        if not ( ( ( currentArguments == ['/bin/bash', '-i'] ) or ( currentArguments == ['/bin/bash'] ) or ( currentArguments == ['_bash'] ) or ( currentArguments == ['_bash', '-i'] ) or ( currentArguments == ['_qalculate', ''] ) or ( currentArguments == ['_qalculate'] ) or ( currentArguments == ['_octave', ''] ) or ( currentArguments == ['_octave'] ) or ( currentArguments == [''] ) ) or ( interactive == True ) ):
            currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
            # ATTENTION: WARNING: Use of 'stdout=subprocess.PIPE' is NOT compatible with interactive shell!
            currentProc = subprocess.Popen([current_ubiquitous_bash, '_bin'] + currentArguments, stdout=subprocess.PIPE, universal_newlines=True)
            (currentOut, currentErr) = currentProc.communicate()
            currentProc.wait()
            currentOut = currentOut.rstrip('\n')
            if currentPrint == True:
                print(currentOut)
                return (currentOut), currentProc.returncode
        else:
            if ( currentArguments == [''] ): currentArguments = ['_bash']
            currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
            currentProc = subprocess.Popen([current_ubiquitous_bash, '_bin'] + currentArguments, universal_newlines=True)
            (currentOut, currentErr) = currentProc.communicate()
            currentProc.wait()
        return (currentOut), currentProc.returncode

# ATTENTION: Only intended for indirect calls.
# https://stackoverflow.com/questions/5067604/determine-function-name-from-within-that-function-without-using-traceback
#	'there aren't enough important use cases given'
# https://www.tutorialspoint.com/How-can-I-remove-the-ANSI-escape-sequences-from-a-string-in-python
# https://docs.python.org/3/library/re.html
#return _bin(currentCommand + currentArguments + currentString, currentPrint)[0]
#return re.sub(r'(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]', '', _bin(currentCommand + currentArguments + currentString, currentPrint)[0])
def _bin_stringAfterArgs(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_false']):
	currentString = [currentString] if isinstance(currentString, str) else currentString
	currentArguments = [currentArguments] if isinstance(currentArguments, str) else currentArguments
	if currentPrint:
		return _bin(currentCommand + currentArguments + currentString, currentPrint)
	else:
		return re.sub(r'\n', '', re.sub(r'(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]', '', _bin(currentCommand + currentArguments + currentString, currentPrint)[0]))

#def _bash(currentArguments = [''], currentPrint = True, current_ubiquitous_bash = "ubiquitous_bash.sh"):
#	_bin(['/bin/bash', '-i'])



#if sys.hexversion < 0x03000000:
#	exit(1)
#_bin_alias = _bin


#_clc('1 + 2')
#_qalculate('1 + 2')
#_octave('1 + 2')
#print(_octave_solve('(y == x * 2, x)' ))

def _clc(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_clc']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def clc(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['clc']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def c(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['c']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def _solve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_solve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def solve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['solve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def nsolve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['nsolve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def _qalculate_solve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_qalculate_solve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def _qalculate_nsolve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_qalculate_nsolve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def _octave_solve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_octave_solve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def _octave_nsolve(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_octave_nsolve']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)


def _qalculate(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_qalculate']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)

def _octave(currentString = [], currentArguments = [], currentPrint = False, currentCommand = ['_octave']):
	return _bin_stringAfterArgs(currentString, currentArguments, currentPrint, currentCommand)








if sys.platform == 'win32':
    try:
        import pyreadline3 as readline
    except ImportError:
        readline = None
else:
    try:
        import readline # optional, will allow Up/Down/History in the console
    except ImportError:
        readline = None
import code

# ATTRIBUTION-AI: ChatGPT o3  2025-04-19
def _enable_readline():
    """
    Make sure arrow keys, history and TAB completion work in the
    interpreter that we embed with code.InteractiveConsole.
    """
    try:
        import readline, rlcompleter, atexit, os
        # basic key bindings
        readline.parse_and_bind('tab: complete')
        # persistent history file
        histfile = os.path.expanduser('~/.pyhistory')
        if os.path.exists(histfile):
            readline.read_history_file(histfile)
        atexit.register(readline.write_history_file, histfile)
    except ImportError:
        # readline (or pyreadline on Windows) is not available
        pass




#_python()
# https://stackoverflow.com/questions/5597836/embed-create-an-interactive-python-shell-inside-a-python-program
def _python():
    _enable_readline()
    variables = globals().copy()
    variables.update(locals())
    shell = code.InteractiveConsole(variables)
    # ATTRIBUTION-AI: ChatGPT 4.1  2025-04-19
    if os.name == 'nt':  # True on Windows
        print(" Press Ctrl+D twice (or Ctrl+Z then Enter) to exit this Python shell.")
    # ATTRIBUTION: NOT AI !
    shell.interact()



import sys
import os
import socket
import string
import re

# ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-18  (partially)
# Determine if running on Windows
is_windows = os.name == 'nt'

# ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-18  (partially)
# Attempt to import colorama if on Windows
use_colorama = False
if is_windows:
    try:
        from colorama import init, Fore, Back, Style
        init(autoreset=True)
        use_colorama = True
    except ImportError:
        pass  # Silently proceed without colorama if import fails

# Color definitions (use ANSI if not on Windows or colorama is not used)
if use_colorama:
    # ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-18  (partially)  ( also the preceeding line  if use_colorama:  )
    class ubPythonPS1(object):
        def __init__(self):
            self.line = 0

        def __str__(self):
            self.line += 1
            user = os.getenv('USER', 'root')
            hostname = socket.gethostname()
            cloud_net_name = os.environ.get('prompt_cloudNetName', '')
            #py_version = f"v{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
            ## ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-19
            #py_version = f"v{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}" if not os.getenv('VIRTUAL_ENV_PROMPT') else os.getenv('VIRTUAL_ENV_PROMPT', '')
            # ATTRIBUTION-AI: ChatGPT o3  2025-04-19
            py_version = os.getenv("VIRTUAL_ENV_PROMPT") or f"Python-v{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
            cwd = os.path.expanduser(os.getcwd())

            home_dir = os.environ.get('HOME', os.environ.get('USERPROFILE', ''))
            if home_dir:
                cwd = re.sub(f'^{re.escape(home_dir)}', '~', cwd)

            # Color definitions (matched to ANSI colors)
            blue = Fore.BLUE
            red = Fore.RED
            green = Fore.GREEN  # Hostname color
            yellow = Fore.YELLOW
            magenta = Fore.MAGENTA  # Python version color
            cyan = Fore.CYAN
            white = Fore.WHITE
            reset = Style.RESET_ALL
            bg_white = Back.WHITE

            if self.line == 1:
                prompt = (
                    f"{blue}|{red}#{red}:{yellow}{user}{green}@{green}{hostname}{blue})-{cloud_net_name}({magenta}{bg_white}{py_version}{reset}{blue}){cyan}|\n"
                    #f"{blue}|{white}[{cwd}]\n"
                    f"{white}{cwd}\n"
                    f"{blue}|{cyan}{self.line}{blue}) {cyan}> {reset}"
                )
            else:
                prompt = (
                    f"{blue}|{red}#{red}:{yellow}{user}{green}@{green}{hostname}{blue})-{cloud_net_name}({magenta}{bg_white}{py_version}{reset}{blue}){cyan}|\n"
                    #f"{blue}|{white}[{cwd}]\n"
                    f"{white}{cwd}\n"
                    f"{blue}|{blue}{self.line}{blue}) {cyan}> {reset}"
                )
            return prompt

    sys.ps1 = ubPythonPS1()
    sys.ps2 = f"{Fore.CYAN}|...{Style.RESET_ALL} "
else:
    # ATTRIBUTION: NOT AI !
    #if sys.hexversion < 0x03060000:
    #	exit(1)
    # https://www.codementor.io/@arpitbhayani/personalize-your-python-prompt-13ts4kw6za
    # https://stackoverflow.com/questions/4271740/how-can-i-use-python-to-get-the-system-hostname
    # https://bugs.python.org/issue20359
    #os.environ['PWD']
    #os.path.expanduser(os.getcwd())
    #\033[0;35;47mpython-%d\033[0m
    #return "\033[92mIn [%d]:\033[0m " % (self.line)
    #return ">>> "
    #return "\033[1;94m|\033[91m#:\033[1;93m%s\033[1;92m@%s\033[1;94m)-%s(\033[1;95m\033[0;35;47mpython-%s\033[0m\033[1;94m)\033[1;96m|\n\033[1;94m|\033[1;97m[%s]\n\033[1;94m|\033[1;96m%d\033[1;94m) \033[1;96m>\033[0m " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
    #return "\033[1;94m|\033[91m#:\033[1;93m%s\033[1;92m@%s\033[1;94m)-%s(\033[1;95m\033[0;35;47mpython-%s\033[0m\033[1;94m)\033[1;96m|\n\033[1;94m|\033[1;97m[%s]\n\033[1;94m|%d\033[1;94m) \033[1;96m>\033[0m " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
    #os.environ['USER']
    #os.getenv('USER','root')
    class ubPythonPS1(object):
        def __init__(self):
            self.line = 0

        def __str__(self):
            self.line += 1
            if self.line == 1:
                #return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;94m\x02|\x01\033[1;97m\x02[%s]\n\x01\033[1;94m\x02|\x01\033[1;96m\x02%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
                #return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;97m\x02%s\n\x01\033[1;94m\x02|\x01\033[1;96m\x02%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
                # ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-19
                return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;97m\x02%s\n\x01\033[1;94m\x02|\x01\033[1;96m\x02%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion) if 'VIRTUAL_ENV_PROMPT' not in os.environ or not os.environ['VIRTUAL_ENV_PROMPT'] else os.environ['VIRTUAL_ENV_PROMPT'], re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
            else:
                #return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;94m\x02|\x01\033[1;97m\x02[%s]\n\x01\033[1;94m\x02|%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
                #return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;97m\x02%s\n\x01\033[1;94m\x02|%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion), re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)
                # ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-19
                return "\x01\033[1;94m\x02|\x01\033[91m\x02#:\x01\033[1;93m\x02%s\x01\033[1;92m\x02@%s\x01\033[1;94m\x02)-%s(\x01\033[1;95m\x02\x01\033[0;35;47m\x02python-%s\x01\033[0m\x02\x01\033[1;94m\x02)\x01\033[1;96m\x02|\n\x01\033[1;97m\x02%s\n\x01\033[1;94m\x02|%d\x01\033[1;94m\x02) \x01\033[1;96m\x02>\x01\033[0m\x02 " % (os.getenv('USER','root'), socket.gethostname(), os.environ.get('prompt_cloudNetName', ''), hex(sys.hexversion) if 'VIRTUAL_ENV_PROMPT' not in os.environ or not os.environ['VIRTUAL_ENV_PROMPT'] else os.environ['VIRTUAL_ENV_PROMPT'], re.sub('^%s' % os.environ['HOME'], '~', os.path.expanduser(os.getcwd()) ), self.line)

    sys.ps1 = ubPythonPS1()
    sys.ps2 = "\x01\033[0;96m\x02|...\x01\033[0m\x02 "


# ATTRIBUTION-AI: OpRt_.nvidia/llama-3.1-nemotron-ultra-253b-v1:free  2025-04-18 (only the next line  if is_windows and not use_colorama:  )
if is_windows and not use_colorama:
    # ATTRIBUTION: NOT AI !
    # https://www.codementor.io/@arpitbhayani/personalize-your-python-prompt-13ts4kw6za
    sys.ps1 = '>>> '
    sys.ps2 = '... '

#_python()

CZXWXcRMTo8EmM8i4d
}


_generate_lean-overrides-python_here() {
	cat << 'CZXWXcRMTo8EmM8i4d'

# WARNING: Strongly discouraged example.
# (strongly prefer to inherit a single os.environ['scriptAbsoluteFolder'] environment variable from being called by an 'ubiquitous_bash' script)
#exec(open(_getScriptAbsoluteFolder()+'/lean.py').read())











# ATTENTION: NOTICE: Environment variables from 'ubiquitous_bash' can be used to import other python scripts.
#exec(open(os.environ['scriptAbsoluteFolder']+'/lean.py').read())

#################################################
# ATTENTION: NOTICE: Add '_prog' script code here!

def _main():
	pass



# ATTENTION: NOTICE: Add '_prog' script code here!
#################################################


import sys
if sys.hexversion > 0x03000000:
	exec('_print = print')

import sys
import string
#./lean.py "_python(c('1 + 2'))" #FAIL
#python3 ./lean.py "_print(c('1 + 2'))"
#python2 ./lean.py "print(c('1 + 2'))"
#./lean.py "_print(c('1 + 2'))"
# https://www.tutorialspoint.com/python/python_command_line_arguments.htm
# https://www.programiz.com/python-programming/methods/built-in/exec
# https://www.geeksforgeeks.org/python-program-to-convert-a-list-to-string/
# https://www.geeksforgeeks.org/python-removing-first-element-of-list/
#print ( 'Argument List:', str(sys.argv) )
#eval( sys.argv[1] + ' ' + ' '.join( sys.argv[2:] ) )
#exec( sys.argv[1] )
#if (1 in sys.argv):
if len(sys.argv) > 1:
	if ( sys.argv[1].startswith('_') ) or ( sys.argv[1].startswith('print') ) :
		exec( sys.argv[1] )


_main()

CZXWXcRMTo8EmM8i4d
}




_generate_lean-python_prog() {
	[[ "$objectName" == "ubiquitous_bash" ]] && return 0
	
	return 1
}

_generate_lean-python() {
	! _generate_lean-python_prog && return 0
	
	echo '#!/usr/bin/env python3' > "$scriptAbsoluteFolder"/lean.py
	
	_generate_lean-lib-python_here "$@" >> "$scriptAbsoluteFolder"/lean.py
	
	_generate_lean-overrides-python_here "$@" >> "$scriptAbsoluteFolder"/lean.py
	
	chmod u+x "$scriptAbsoluteFolder"/lean.py
}






# 
# _python_hook_here() {
# 	cat << CZXWXcRMTo8EmM8i4d
# 	
# 	_setupUbiquitous_accessories_here-python_hook
# 	
# CZXWXcRMTo8EmM8i4d
# }
# 
# 
# _python_hook() {
# 	_messageNormal "init: _python_hook"
# 	local ubHome
# 	ubHome="$HOME"
# 	[[ "$1" != "" ]] && ubHome="$1"
# 	
# 	export ubcoreDir="$ubHome"/.ubcore
# 	
# 	_python_hook_here > "$ubcoreDir"/python_bash_rc
# }
# 































