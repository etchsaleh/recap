# recap.
An extraction-based text summarization iOS app. (originally written in C)
-
**recap.** is an extraction-based text summarization tool that ranks the sentences within the text by importance. It reorganizes the summary to focus on a certain topic; by selection of the most frequent keyword. It extracts the most important sentences and removes insignificant transition phrases, unnecessary clauses, and excessive examples.

<p align="center">
  <img src="https://i.imgur.com/yXRdZHP.png" width="935" height="420" />
</p>

The algorithm works by these simplified steps:
 - Calculate the occurrence of each word in the text.
 - Associate words with their grammatical counterparts. (e.g. "create” and "creativity”)
 - Assign each word with points depending on their popularity (frequency in the text).
 - Split up the text into individual sentences.
 - Rank sentences by the sum of their words' points.
 - Return some of the most highly ranked sentences in chronological order.
 
 © 2016 Hesham Saleh. All Rights Reserved.
