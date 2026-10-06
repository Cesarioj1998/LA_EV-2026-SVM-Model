# Predicting Hits with SVM: 2026 Balls in Play
# Uses launch angle and exit velocity to classify each ball in play as a hit or an out

library(kernlab)

# C value for the rbfdot model. Change this one number to rerun with a different C
# (values tested in the writeup: 0.01, 0.1, 1, 100, 1000)
C_val <- 1000

# ---- Load data ----
data <- read.csv("Mar_Sept_2026 Hits v Outs.csv", header = TRUE)

# ---- Clean data: keep only balls in play with launch speed and launch angle ----
has_LS <- !is.na(data$launch_speed)
has_LA <- !is.na(data$launch_angle)

bip <- data[has_LS & has_LA, ]

# ---- Create response variable: 1 = hit, 0 = out ----
bip$hit <- bip$events %in% c("single", "double", "triple", "home_run")
bip$hit <- ifelse(bip$hit, 1, 0)

# Baseline: share of outs in the full data
print(table(bip$hit))

# ---- Random sample of 10,000 balls in play for training ----
set.seed(42)
idx <- sample(nrow(bip), 10000)
bip_sample <- bip[idx, ]

print(table(bip_sample$hit))

# ---- Test set: every ball in play not in the sample ----
bip_test <- bip[-idx, ]

# ---- Linear model (vanilladot) ----
set.seed(42)
model_lin <- ksvm(as.matrix(bip_sample[, c("launch_angle", "launch_speed")]),
                  as.factor(bip_sample$hit), type = "C-svc", kernel = "vanilladot",
                  C = 100, scaled = TRUE)

pred_lin <- predict(model_lin, bip_sample[, c("launch_angle", "launch_speed")])
print(sum(pred_lin == bip_sample$hit) / nrow(bip_sample))
print(table(pred_lin))

# ---- rbfdot model ----
set.seed(42)
model <- ksvm(as.matrix(bip_sample[, c("launch_angle", "launch_speed")]),
              as.factor(bip_sample$hit), type = "C-svc", kernel = "rbfdot",
              C = C_val, scaled = TRUE)

# Training accuracy
pred <- predict(model, bip_sample[, c("launch_angle", "launch_speed")])
print(sum(pred == bip_sample$hit) / nrow(bip_sample))
print(table(pred))

# Test accuracy and confusion matrix (rows = predicted, columns = actual)
pred_test <- predict(model, bip_test[, c("launch_angle", "launch_speed")])
print(sum(pred_test == bip_test$hit) / nrow(bip_test))
print(table(pred_test, bip_test$hit))

# ---- Plots ----
add_legend <- function() {
  legend("bottomleft",
         legend = c("Hit", "Out"),
         col = c("red", "gray"),
         pch = 16,
         bty = "n")
}

# Actual outcomes, sample set
plot(bip_sample$launch_speed, bip_sample$launch_angle,
     col = ifelse(bip_sample$hit == 1, "red", "gray"),
     pch = 16, cex = 0.4,
     xlab = "Exit Velocity (mph)",
     ylab = "Launch Angle (degrees)",
     main = "Actual Outcomes (2026), Sample Set")
add_legend()

# Predicted outcomes, sample set
plot(bip_sample$launch_speed, bip_sample$launch_angle,
     col = ifelse(pred == 1, "red", "gray"),
     pch = 16, cex = 0.4,
     xlab = "Exit Velocity (mph)",
     ylab = "Launch Angle (degrees)",
     main = paste("SVM Predicted Outcomes (2026), Sample Set (C=", C_val, ")", sep = ""))
add_legend()

# Actual outcomes, test set
plot(bip_test$launch_speed, bip_test$launch_angle,
     col = ifelse(bip_test$hit == 1, "red", "gray"),
     pch = 16, cex = 0.2,
     xlab = "Exit Velocity (mph)",
     ylab = "Launch Angle (degrees)",
     main = "Actual Outcomes (2026), Test Set")
add_legend()

# Predicted outcomes, test set
plot(bip_test$launch_speed, bip_test$launch_angle,
     col = ifelse(pred_test == 1, "red", "gray"),
     pch = 16, cex = 0.2,
     xlab = "Exit Velocity (mph)",
     ylab = "Launch Angle (degrees)",
     main = paste("SVM Predicted Outcomes (2026), Test Set (C=", C_val, ")", sep = ""))
add_legend()
