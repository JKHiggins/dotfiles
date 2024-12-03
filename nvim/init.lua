local home = os.getenv('HOME')
vim.env.PYENV_VERSION = vim.fn.system('pyenv version'):match('(%S+)%s+%(.-%)')
vim.g.python3_host_prog = home .. "/.pyenv/shims/python3"

require("jhiggins")
