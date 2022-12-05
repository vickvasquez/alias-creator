# alias-creator
> Is a simple script for create alias automatically from a folder path

This script current support next files to create the alias
`.zshrc .bashrc .bash_alias .bash_profile .profile`, automatically selects the first file it finds in `$HOME`

## Installation
```bash
git clone https://github.com/vickvasquez/alias-creator.git
cd alias-creator
chmod +x ./alias-creator
```

## Usage
```bash
./alias-creator.sh ~/Documents
```
After finish, automatically create a file with name `./my-aliases/Documents` in `$HOME` path

## Example
```bash
Structure folder
  - folder-test
    - foo/
    - bar/
    - baz/
```

```bash
./alias-creator.sh ~/folder-test
source ~/.zshrc
```
Now have available the next alias `foo, bar, baz`

```
> bar
```

Automatically change directory to `~folder-test/bar/`