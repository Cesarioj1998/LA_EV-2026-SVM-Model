library(kernlab)
data <- read.csv("Mar_Sept_2026 Hits v Outs.csv", header = TRUE)

has_LS <- !is.na(data$launch_speed)
has_LA <- !is.na(data$launch_angle)

bip <- data[has_LS & has_LA, TRUE]

bip$hit <- bip$events%in% c("single", "double", "triple", "home_run")
bip$hit <- ifelse(bip$hit,1,0)

set.seed(42)

idx <- sample(nrow(bip),10000)

bip_sample <- bip[idx,]

set.seed(42)
model_lin <- ksvm(as.matrix(bip_sample[,c("launch_angle","launch_speed")]),
                  as.factor(bip_sample$hit), type="C-svc", kernel="vanilladot",
                  C=1000, scaled=TRUE)
pred_lin <- predict(model_lin, bip_sample[,c("launch_angle","launch_speed")])
sum(pred_lin == bip_sample$hit) / nrow(bip_sample)
table(pred_lin)

set.seed(42)

model <- ksvm(as.matrix(bip_sample[,c("launch_angle","launch_speed")]),
              as.factor(bip_sample$hit),type="C-svc",kernel="rbfdot",
              C=1000,scaled=TRUE)

pred <- predict(model,bip_sample[,c("launch_angle","launch_speed")])

sum(pred == bip_sample$hit) / nrow(bip_sample)

table(pred)

plot(bip_sample$launch_speed,bip_sample$launch_angle,
     col = ifelse(bip_sample$hit == 1, "red", "gray"),
     pch = 16, cex = 0.4,
     xlab = "Exit Velocity (mph)",
     ylab = "Launch Angle (degrees)",
     main = "Actual Outcomes (2026), Sample Set")

legend("bottomleft",
       legend = c("Hit", "Out"),
       col = c("red", "gray"),
       pch = 16,
       bty = "n")

plot(bip_sample$launch_speed,bip_sample$launch_angle,
     col = ifelse(pred == 1, "red", "gray"),
     pch = 16, cex = 0.4,
     xlab = "Exit Velocity (mph)",
     ylab = "Launch Angle (degrees)",
     main = "SVM Predicted Outcomes (2026), Sample Set (C=1000)")

legend("bottomleft",
       legend = c("Hit", "Out"),
       col = c("red", "gray"),
       pch = 16,
       bty = "n")

bip_test <- bip[-idx,]

set.seed(42)

model <- ksvm(as.matrix(bip_sample[,c("launch_angle","launch_speed")]),
              as.factor(bip_sample$hit),type="C-svc",kernel="rbfdot",
              C=1000,scaled=TRUE)

pred_test <- predict(model,bip_test[,c("launch_angle","launch_speed")])

sum(pred_test == bip_test$hit) / nrow(bip_test)

table(pred_test, bip_test$hit)

plot(bip_test$launch_speed,bip_test$launch_angle,
     col = ifelse(bip_test$hit == 1, "red", "gray"),
     pch = 16, cex = 0.2,
     xlab = "Exit Velocity (mph)",
     ylab = "Launch Angle (degrees)",
     main = "Actual Outcomes (2026), Test Set")

legend("bottomleft",
       legend = c("Hit", "Out"),
       col = c("red", "gray"),
       pch = 16,
       bty = "n")

plot(bip_test$launch_speed,bip_test$launch_angle,
     col = ifelse(pred_test == 1, "red", "gray"),
     pch = 16, cex = 0.2,
     xlab = "Exit Velocity (mph)",
     ylab = "Launch Angle (degrees)",
     main = "SVM Predicted Outcomes (2026), Test Set (C=1000)")

legend("bottomleft",
       legend = c("Hit", "Out"),
       col = c("red", "gray"),
       pch = 16,
       bty = "n")
