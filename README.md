# Predicting Hits with SVM: 2026 Balls in Play

A support vector machine (SVM) model built in R that predicts whether a ball in play is a hit or an out using only launch angle and exit velocity, trained and tested on every ball in play from the 2026 MLB regular season (Statcast data via Baseball Savant).

## Results

Using an rbfdot kernel, the model correctly classified about 80% of 110,879 balls in play it never saw during training, compared to a 67.5% baseline from predicting an out every time. A linear model couldn't beat the baseline at all, since hits sit in a pocket in the middle (line drives and hard contact) rather than on one side of a straight line.

| C | Training accuracy | Test accuracy |
| --- | --- | --- |
| 0.01 | 0.7580 | 0.7583 |
| 0.1 | 0.7936 | 0.7928 |
| 1 | 0.7980 | 0.7994 |
| 100 | 0.8017 | 0.8049 |
| 1000 | 0.8044 | 0.8064 |

![Actual outcomes, test set](Outcome_plots/YOUR_ACTUAL_TEST_FILENAME.png)
![Predicted outcomes, test set, C=1](Outcome_plots/YOUR_C1_TEST_FILENAME.png)

Low C values underfit and missed the line drive zone entirely, while high C values picked up small memorized islands at low exit velocity. The remaining errors are mostly bloops, infield singles, and well hit balls caught by fielders, which launch angle and exit velocity alone can't capture.

## Files

- **Predicting Hits with SVM_2026 BIP.pdf**: full writeup with methodology, results, and discussion
- **Mar_Sept LA EV Project.R**: R script (uses the kernlab package)
- **Outcome_plots/**: actual vs predicted outcome plots for each C value

## Data

The data isn't included in this repo. To reproduce it, run a Baseball Savant Statcast search for the 2026 regular season (March through September), export the CSV, and save it as `Mar_Sept_2026 Hits v Outs.csv` in the same folder as the script.

## Next steps

Adding spray angle and sprint speed as predictors, and switching to probability outputs to build an expected batting average for each hitter.
