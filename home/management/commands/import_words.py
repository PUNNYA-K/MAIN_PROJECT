import pandas as pd
from django.core.management.base import BaseCommand
from home.models import Words

class Command(BaseCommand):
    help = "Import words from an Excel file"

    def handle(self, *args, **kwargs):
        file_path = "C:/Users/punny/Desktop/Dictionary/dict_words.xlsx"  # Update with actual path

        try:
            # Read the Excel file
            df = pd.read_excel(file_path)

            # Rename columns to match model field names
            df.rename(columns={
                "Word": "word",
                "Grammatical Category": "grammatical_category",
                "Phonetic": "phonetics",
                "Translation": "translation",
                "Meaning": "meaning",
                "Example": "example_sentence",
                "Synonyms": "synonyms",
                "Antonyms": "antonyms",
            }, inplace=True)

            # Debug: Print column names
            print("Updated Columns:", df.columns.tolist())

            # Debug: Print first few rows
            print("First few rows:\n", df.head())

            words_list = []

            for _, row in df.iterrows():
                word = str(row.get("word", "")).strip()

                if word:  # Ensure word is not empty
                    words_list.append(Words(
                        word=word,
                        grammatical_category=str(row.get("grammatical_category", "")).strip(),
                        phonetics=str(row.get("phonetics", "")).strip(),
                        translation=str(row.get("translation", "")).strip(),
                        meaning=str(row.get("meaning", "")).strip(),
                        example_sentence=str(row.get("example_sentence", "")).strip(),
                        synonyms=str(row.get("synonyms", "")).strip(),
                        antonyms=str(row.get("antonyms", "")).strip(),
                        transliteration=str(row.get("transliteration", "")).strip(),
                    ))

            if words_list:
                Words.objects.bulk_create(words_list, ignore_conflicts=True)
                self.stdout.write(self.style.SUCCESS(f"{len(words_list)} words imported successfully!"))
            else:
                self.stderr.write(self.style.ERROR("No valid words found to insert!"))

        except Exception as e:
            self.stderr.write(self.style.ERROR(f"Error importing words: {e}"))
