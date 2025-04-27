import sys
from pathlib import Path

from loguru import logger

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from config import cfg
from huggingface_hub import HfApi


def sync_hf_content(repo_type, repo_paths):
    api = HfApi(token=cfg.HF_TOKEN)

    for repo_id, repo_path in repo_paths:
        api.upload_folder(
            folder_path=f"{cfg.DATA_LAKE}/{repo_id}/{repo_path}",
            repo_id=f"{cfg.HF_ACCOUNT}/{repo_id}",
            path_in_repo=repo_path,
            repo_type=repo_type,
            ignore_patterns=[
                "**/logs/*.log",
                "*.db",
                "*.sqlite",
                "*.DS_Store",
                "*.gitattributes",
            ],
        )
        logger.success(
            f"Uploaded {repo_path} to {cfg.HF_ACCOUNT}/{repo_id} successfully."
        )


def sync_hf(repo_type: str = "dataset"):
    repo_paths = {
        "dataset": [
            ("public", "/extract"),
            ("public", "/load"),
            ("public", "/transform"),
        ],
        "model": [
            ("public", "/models"),
            ("public", "/modeling"),
        ],
    }

    if repo_type in repo_paths:
        sync_hf_content(repo_type, repo_paths[repo_type])
    else:
        logger.error(f"Unsupported content type: {repo_type}")
