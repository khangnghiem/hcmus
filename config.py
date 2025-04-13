import os
from datetime import date
from dotenv import load_dotenv
from typing import Union, get_type_hints


def _parse_bool(value: Union[str, bool]) -> bool:
    return value if type(value) is bool else value.lower() in ("true", "1", "t")


class Config:
    DEBUG: str = "False"
    ENV: str = "dev"
    DATA_LAKE: str
    LOG_DIR: str
    LOG_LEVEL: str
    HF_TOKEN: str
    COOKIE: str
    today: str = date.today().strftime("%Y-%m-%d")

    def __init__(self):
        load_dotenv()
        env = os.environ
        for field in self.__annotations__:
            if not field.isupper():
                continue

            default_value = getattr(self, field, None)
            if default_value is None and env.get(field) is None:
                raise ValueError(f"Environment variable {field} is not set")
            try:
                var_type = get_type_hints(self)[field]
                if var_type is bool:
                    value = _parse_bool(env.get(field, default_value))
                else:
                    value = var_type(env.get(field, default_value))

                self.__setattr__(field, value)
            except ValueError:
                raise ValueError(
                    f"Unable to convert {field} to {var_type} for {env.get(field)}"
                )


cfg = Config()
