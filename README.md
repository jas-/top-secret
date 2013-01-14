# Poor mans GitHub
I am poor, and well poor does what poor can.

## Saving to your poor man private repository on GitHub
Here is a small bit to help you create a private repo. Open up your .bashrc or alias file of choice and add the following:
```sh
repo_save()
{
    if [ -d "$1" ] ; then
        cd $1;
        tar --exclude=".git*" --exclude="*.tgz" -zcf $2.tgz $1 2&>/dev/null;
        read -sp "Enter password: " pass;
        gpg --yes --no-tty --batch --passphrase-fd 3 --symmetric -o $2.tgz.gpg $2.tgz 3<<<$pass;
        git add $2.tgz.gpg README.md;
        git commit -m "`date`";
        git push;
        rm $2.tgz 2&>/dev/null;
    fi
}
alias repo-save=repo_save;
```

Then whenever you wish to save to your (already configured repo using your already available public key), simply execute like so...

```sh
bash> repo-save /path/to/repo filename
```

## Retoring from your poor man private repository on GitHub
Of course in order for you to keep multiple machines in sync you must pull and merge, decrypt & extract:
```sh
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
```

Now use like this...

```sh
bash> repo-restore filename
```


