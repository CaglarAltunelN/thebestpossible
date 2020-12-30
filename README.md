### My repo
The repository contains some of my work that I have done since March 2020. 

#### Pogba or Modric
The idea was that Pogba was a more effective player at the offensive side of the game. I compared his shot assists with Modric's.
The quality measure that I paid regard while comparing their shot assists was the xG that the shot pass creates. 
The visualization shows Pogba had much less shot assits compared to Modric during the WC 2018, as he was tasked to play as a deep lying playmaker.
However, it can be easily seen that the rare chances that Pogba creates had much higher quality in general, compared to those created by Modric.

#### The xP Index - A metric designed to find out effective passers
The aim was deriving a pass quality metric. I used a sample of 50.000 passes from Premier League and created an expected pass model by logistic regresson.
When a probability of being successful for each pass is calculated, then it was easy to see what players exceed the expectations in terms of pass completion. 
After creating the metric, not surprisingly, the outcome is highly correlated with the pass accuracy in general.
But I focused on the top right corner of pass accuracy vs the xP index plot, to identify elite passers, only among midfielders. 
Then I increased my focus into who exceeds expectations in terms of the xP index level given their pass accuracies. 
I noted these players down as potentially very effective passers who manage to create successful pass attempts under tougher situations. 

#### Match Score model - A new fairness metric and an equation to simulate the following season by adjusting relative financial values of clubs
The pdf file (InterMilan_EndSeasonReview-ClubPerformance) covers our team's final report delivered for the completion of David Sumpter's Mathematical Modelling in Football course. 
I took an active role in formulating the metrics (such as weighting of expected goals and expected threats) and the simulation modelling parts of the club performance report. 
Under the relevant folder, you can find the code for how to build a match score model by making use of a new fairness metric (weighted xG and xT values). 
The idea was brought to the table by my team leader Lodve Berre (https://www.linkedin.com/in/lodve-berre/). 
His initial idea was that in some games, one team purely dominates the game with possession, while failing at converting this dominance to shots, or vice versa, therefore, we should come up with something potentially more fair than only the xG itself. 
Accordingly, since xG is purely shot based, while xT (Please see Karun Singh's beautiful article for the detailed definition odf xT: https://karun.in/blog/expected-threat.html.) rewards attacking actions regardless of the end outcome of the possession, I came up with a new metric that weights xG and xT with respect to shot ratio and possession for each team in each game. 
In addition, during the project period, we opted for using FiveThirthyEight's (https://fivethirtyeight.com/) attack and defense attributes as base to simulate the following season of Serie A. 
In line with what I did for xG and xT, I formulated a value that weights the attacking attribute of the team and the defensive attribute of the opponent with each club's SPI (A general point for each club calculated by FiveThirtyEight). 
To create possible financial scenarios, I also created a seperate automated excel sheet which calculates each team's relative SPI with respect to different financial scenarios (Based on club's value growth.). 

#### Bias-variance tradeoff in time series

Bias-variance tradeoff is an important concept that one must always pay regard when modelling for both prediction and forecasting purposes. 
There are several measures that provides us what the best fit is while modelling, such as minimum mean squared error (MSE), AIC etc. 
However, while minimizing these values, we may create a model that captures almost the entire bias (low bias) in the data that is used for modelling, but significantly fails in another data simply because that happens to be "so specific" for the dataset we used (high variance). 
This is called overfitting, refers to when a statistical model incorporates noise rather than real patterns in the data. 
Long story short, while making our model less biased, we increase variance. Therefore, we must build models that can be generalized so that we reach more or less the same accuracy when tested on a different dataset. 
Below code provides an example of bias-variance tradeoff and overfitting in time series. 
The target is to forecast final consumption expenditure of Australia, for the period quarter one of 2013 - quarter four of 2018, by making use of the training time series quarter two of 1959 - quarter four of 2012. 
The dataset can be downloaded from: https://stats.oecd.org/Index.aspx?DataSetCode=QNA. 
I would like to thank so much to my thesis partner, Hallvard Holte for his exceptional contribution. PDF file in the relevant folder covers both R codes and explanations, while pure codes are also provided. One can see the same report in .rmd format as well. 


