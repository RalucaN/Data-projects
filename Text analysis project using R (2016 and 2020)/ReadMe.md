<b>Disclaimers</b>:
* This is <b>my first text analysis project</b>, dating back to <b>June 2016</b>, when I was in the first year of the PhD programme. Thus, the writing skills are representative of that time and have improved substantially until today. No updates have been made to the paper ever since.
* It represents an example of application of different content and dictionary-based methods of analysis to the 2016 Democratic candidate debate of the US presidential elections. Details about the methodology and findings are available below. 
* <i>Purpose and outcome</i>: It was submitted for the completion of the "Quantitative text analysis" postgraduate course at Trinity College Dublin, and received the grade "A-".
* <i>Regarding the quanteda package</i>: At the time of this analysis, the quanteda packaged offered the widest range of content-based methods of analysis. Nevertheless, since the completion of this investigation, the quanteda packages has been significantly updated and improved. Thus, it is possible that some of the functions, mentioned in the R script, are now deprecated and that new functions have been implemented. Over the next weeks, I plan to review the R code and upload a 2020 updated version that will also include, additionally, a machine learning algorithm. This will represent an example of an old project that has been revised and improved :nerd_face:
<br>
<br>
<b>Title of the paper</b>: Profiling electoral candidates: an automated content analysis of a 2016 presidential debate of US Democratic Party’s candidates
<br>
<br>

<b>Issue of interest</b>: Creating the profile of the US democratic candidate for the 2016 presidential election.
<br>

<b>Research questions</b>:
* <i>Can we talk about a general profile of a US democrat politician during the 2016 presidential elections?</i>
* <i>If yes, what are the features of a 2016 US democrat candidate for presidency?</i>
<br>

<b>Motivation</b>:
* <i>for choosing the data</i>: at the time of this investigation, this was the most recent debate engaging two major democratic candidates running for the 2016 US presidential election.
* page 4
<br>

<b>Data</b>: 
* Includes the transcript of the last internal debate of the Democratic Party's candidates from 14th of April 2016. It took place in Brooklyn, New York and was moderated by the CNN reporter Wolf Blitzer while Dana Bash, also from CNN and Errol Louis, from NY1 were panelists (Source: American Presidential Project).
* Covers two influential personalities from the contemporary US Democratic Party: Hillary Clinton and Bernie Sanders.
<br>

<b>Methods</b>:
* lexical diversity 
* contextual key concepts
* readability
<br>

<b>Description of the text corpus</b>:
* contains 399 documents (speech acts) with 16999 words spoken
* top 10 frequent features (word stems):

<br>

<b>Software and package/library used</b>:
* The whole analysis has been performed in R, using the functions available in the [quanteda package](https://quanteda.io/)
*
<br>

<b>Data analysis steps</b>:
1. Data collection - data obtained from the online database of [The American Presidency Project](https://www.presidency.ucsb.edu/documents/democratic-candidates-debate-brooklyn-new-york) and exported into a txt file.
2. Data pre-processing - identified and manually removed the following non-lexical remarks in brackets: “[applause]”, “[laughter]”, “[inaudible]”, “[booing]”, “[cheering and applause]”, “[crosstalk]”, “[cheering]” and “[commercial break]” because they are not relevant for my analysis
Afterwards, I imported the document in R using the textfile() command from the Quanteda package and segmented the whole text by speaker. I have also performed additional cleaning actions to remove all the unwanted spaces and colons from the tags. Finally, I deleted the “Member” speaker because it indicates a vocalized protest from the audience which does not influence in any way the content of the debate.
3. Data exploration
4. Data analysis
5. Extension

<br>
