import torch
from torch.utils.data import Dataset
import polars as pl
from transformers import Trainer, TrainingArguments

class SentimentDataset(Dataset):
    def __init__(
        self,
        dataset: pl.DataFrame,
        tokenizer,
        text_column: str = None,
        label_column: str = None,
        max_len=128,
    ):
        self.texts = (
            dataset[text_column].to_list() if text_column else dataset[:, 0].to_list()
        )
        self.labels = (
            dataset[label_column].to_list() if label_column else dataset[:, 1].to_list()
        )
        self.encodings = tokenizer.encode(
            self.texts, truncation=True, padding=True, max_length=max_len
        )

    def __getitem__(self, idx):
        item = {
            key: torch.tensor(val[idx]) for key, val in dict(self.encodings).items()
        }
        item["labels"] = torch.tensor(self.labels[idx])
        return item

    def __len__(self):
        return len(self.labels)


def train_model(model, tokenizer, train_dataset, test_dataset, model_name):
    training_args = TrainingArguments(
        output_dir=f'./results/{model_name}',
        num_train_epochs=4,
        per_device_train_batch_size=16,
        per_device_eval_batch_size=64,
        evaluation_strategy="epoch",
        save_strategy="epoch",
        logging_dir=f'./logs/{model_name}',
        load_best_model_at_end=True,
        metric_for_best_model="accuracy",
    )

    def compute_metrics(eval_pred):
        import numpy as np
        from sklearn.metrics import accuracy_score
        logits, labels = eval_pred
        predictions = np.argmax(logits, axis=-1)
        return {"accuracy": accuracy_score(labels, predictions)}

    trainer = Trainer(
        model=model,
        args=training_args,
        train_dataset=train_dataset,
        eval_dataset=test_dataset,
        compute_metrics=compute_metrics,
    )

    trainer.train()
    return trainer
