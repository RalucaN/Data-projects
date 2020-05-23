# This script contains the steps for replicating the analysis

# Loading R package(s)
require(quanteda)
library(stargazer)

# Loading the texts and creation of corpus
Debate_2016<-textfile("2016.txt")
Corpus_2016 <- corpus(Debate_2016, 
                      notes = "Democratic Candidates Debate, Brooklyn 2016-04-14",
                      source = "http://www.presidency.ucsb.edu/ws/index.php?pid=116995")

summary(Corpus_2016)

# Cleaning
Corpus_2016 <- segment(Corpus_2016, what = "tags", delimiter = "\\s*[[:upper:]]+:\\s+")
summary(Corpus_2016, 10)
docvars(Corpus_2016, "tag") <- gsub(":", "", docvars(Corpus_2016, "tag"))
docvars(Corpus_2016, "tag") <- stringi::stri_trim_both(docvars(Corpus_2016, "tag"))
Corpus_2016 <- subset(Corpus_2016, !(tag %in% c("MEMBER")))

# Other cleaning actions done manually in MS Word - Remove of [applause] [laughter] [inaudible] [booing] [cheering and applause] [crosstalk] [cheering] [commercial break].


# Descriptive statistics
Dfm2016 <- dfm(Corpus_2016, ignoredFeatures = c(stopwords("english"), "will"), stem = TRUE)
topfeatures(Dfm2016)
syllables(texts(Corpus_2016, "tag")) # total syllabes by speaker
sum(syllables(texts(Corpus_2016)))# total number of syllabes
table(docvars(Corpus_2016, "tag")) # total speech acts by speaker
stargazer(summary(Corpus_2016), summary= FALSE, title="Descriptive statistics", type = "html", style = "apsr", out = "descriptivestats.html")


# Computing the number of words spoken
par(mar = c(5, 6, .5, 1))
barplot(sort(ntoken(texts(Corpus_2016, groups = "tag"), removePunct = TRUE)), 
        horiz = TRUE, las = 1, xlab = "Total Words Spoken")

# Counting the number of characters
nchar(texts(Corpus_2016, groups = "tag")) # total number of characters per speaker

# Top features per speaker
topfeatures(dfm(subset(Corpus_2016, tag == "CLINTON"), ignoredFeatures = c(stopwords("english"), "will"), stem = TRUE))
plot(dfm(subset(Corpus_2016, tag == "CLINTON"), ignoredFeatures = c(stopwords("english"), "will"), stem = TRUE))
topfeatures(dfm(subset(Corpus_2016, tag == "SANDERS"), ignoredFeatures = c(stopwords("english"), "will"), stem = TRUE))
plot(dfm(subset(Corpus_2016, tag == "SANDERS"), ignoredFeatures = c(stopwords("english"), "will"), stem = TRUE))


# Key-words in context
kwic(subset(Corpus_2016, tag == "CLINTON"), "go", window = 3)
kwic(subset(Corpus_2016, tag == "CLINTON"), "suppot", window = 3)
kwic(subset(Corpus_2016, tag == "SANDERS"), "got", window = 3)
kwic(subset(Corpus_2016, tag == "SANDERS"), "country", window = 3)

# Readability
demread <- readability(texts(Corpus_2016, groups = "tag"), measure = c("Flesch.Kincaid")) # Flesch-Kincaid index
dotchart(demread, xlab = "Readability based on Flesch-Kincaid index")
demread2 <- readability(texts(Corpus_2016, groups = "tag"), measure = c("FOG")) # FOG index
dotchart(demread2, xlab = "Readability based on FOG index")

# Lexical diversity
demlexdiv <- lexdiv(dfm(Corpus_2016, groups = "tag"), measure = c("CTTR"))
dotchart(demlexdiv, xlab = "Lexical diversity")

# Similarity
similarity(dfm(Corpus_2016, groups = "tag"), margin = c("documents"), method = "correlation")
similarity(dfm(Corpus_2016, groups = "tag"), margin = c("documents"), method = "cosine")

