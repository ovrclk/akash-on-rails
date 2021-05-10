env 'SHELL', '/bin/bash'
env 'BASH_ENV', '/container.env'

every 15.minute do
  command '/scripts/backup-postgres.sh > /proc/1/fd/1 2>&1'
end
