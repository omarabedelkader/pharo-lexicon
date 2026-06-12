import os
import nltk

nltk.download("brown")
nltk.download("gutenberg")

from nltk.corpus import brown, gutenberg

os.makedirs("data/corpora", exist_ok=True)

with open("data/corpora/brown.txt", "w", encoding="utf-8") as f:
    f.write(" ".join(brown.words()))

with open("data/corpora/gutenberg.txt", "w", encoding="utf-8") as f:
    f.write(" ".join(gutenberg.words()))

print("DONE: created data/corpora/brown.txt")
print("DONE: created data/corpora/gutenberg.txt")