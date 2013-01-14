# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
repo_save()
{
    if [ -d "$1" ] ; then
	cd $1;
        tar --exclude=".git*" --exclude="*.tgz" -zcf $2.tgz $1 2&>/dev/null;
	read -sp "Enter password: " pass;
        gpg --yes --no-tty --batch --passphrase-fd 3 --symmetric -o $2.tgz.gpg $2.tgz 3<<<$pass 2&>/dev/null;
        git add $2.tgz.gpg README.md .bashrc;
        git commit -m "`date`";
        git push;
        rm $2.tgz 2&>/dev/null;
    fi
}
alias repo-save=repo_save;

repo_restore()
{
    git pull;
    git merge master origin/master;
    read -sp "Enter password: " pass;
    gpg --yes --no-tty --batch --passphrase-fd 3 --decrypt -o $1.tgz $1.tgz.gpg 3<<<$pass 2&>/dev/null;
    tar zxf $1.tgz 2&>/dev/null;
    rm $1.tgz 2&>/dev/null;
}
alias repo-restore=repo_restore;

