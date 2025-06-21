# 1. For NEW GitHub users

Please pull then checkout a development branch and create a Pull Request to merge into main:

- pull:
```sh
git pull # pull new content from the current branch
git fetch # fetch new content in main branch
```

- checkout:
```sh
git checkout -b <new_branch_name> # (first time)
git checkout <branch_name> # (not first time)
```

- write code and select files to commit: Open Command Pallete --> Source Control: Repositories --> Select your files
- commit these files:

```sh
git commit -m "<your commit message>"
git push
```

# 2. Folder structure

| folder    | purpose                                 |     |
| --------- | --------------------------------------- | --- |
| .venv     | virtual env for uv sync below           |     |
| analytics | ML and data analysis                    |     |
| courses   | contains materials for each course      |     |
| extract   | extract data                            |     |
| load      | structure and store in db/parquet       |     |
| transform | transform data into meaningful insights |     |
| utils     | helpers and utility functions           |     |

# 3. Package Management

## 3.1. Install uv

```sh
pip install uv 
```

## 3.2. Sync packages

```sh
uv python pin 3.12
uv sync
```

# 4. Create an .env file

with the following content:

```zsh
DEBUG=True
DATA_LAKE="{your data lake directory}"
HF_TOKEN="{your Hugging Face token}"
COOKIE="{your cookie}"
```
