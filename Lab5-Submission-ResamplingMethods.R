# Consider a library as the location where packages are stored.
# Execute the following command to list all the libraries available in your
# computer:
.libPaths()
# Then execute the following command to see which packages are available in
# each library:
lapply(.libPaths(), list.files)

# If renv::restore() did not install the "languageserver" package (required to
# use R for VS Code), then it can be installed manually as follows (restart R
# after executing the command):

if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
# STEP 1. Install and Load the Required Packages ----
## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## klaR ----
if (require("klaR")) {
  require("klaR")
} else {
  install.packages("klaR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## e1071 ----
if (require("e1071")) {
  require("e1071")
} else {
  install.packages("e1071", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## readr ----
if (require("readr")) {
  require("readr")
} else {
  install.packages("readr", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## LiblineaR ----
if (require("LiblineaR")) {
  require("LiblineaR")
} else {
  install.packages("LiblineaR", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## naivebayes ----
if (require("naivebayes")) {
  require("naivebayes")
} else {
  install.packages("naivebayes", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
data("PimaIndiansDiabetes")
summary("pima_indians_diabetes")
str("pima_indians_diabetes")
## 1. Split the dataset ====
# Define a 75:25 train:test data split of the dataset.
# That is, 75% of the original data will be used to train the model and
# 25% of the original data will be used to test the model.
# Split the dataset into a training and test set
train_index <- createDataPartition(PimaIndiansDiabetes$diabetes, p = 0.80, list = FALSE)
PimaIndiansDiabetes_train <- PimaIndiansDiabetes[train_index, ]
PimaIndiansDiabetes_test <- PimaIndiansDiabetes[-train_index, ]
## 2. Train a Naive Bayes classifier using the training dataset ----

### 2.a. OPTION 1: "NaiveBayes()" function in the "klaR" package ----
PimaIndiansDiabetes_model_nb_klaR <- # nolint
  klaR::NaiveBayes(diabetes ~ ., data = PimaIndiansDiabetes_train)

### 2.b. OPTION 2: "naiveBayes()" function in the e1071 package ----
PimaIndiansDiabetes_model_nb_e1071 <- # nolint
  e1071::naiveBayes(diabetes ~ ., data = PimaIndiansDiabetes_train)

## 3. Test the trained Naive Bayes model using the testing dataset ----
PimaIndiansDiabetes_predictions_nb_e1071 <-
  predict(PimaIndiansDiabetes_model_nb_e1071, PimaIndiansDiabetes_test[, -9])

## 4. View the Results ----
### 4.a. e1071 Naive Bayes model and test results using a confusion matrix ----
print(PimaIndiansDiabetes_model_nb_e1071)
caret::confusionMatrix(PimaIndiansDiabetes_predictions_nb_e1071, PimaIndiansDiabetes_test$diabetes)
# The confusion matrix can also be viewed graphically,
# although with less information.
plot(table(PimaIndiansDiabetes_predictions_nb_e1071, PimaIndiansDiabetes_test$diabetes))
## 2. Train a linear regression model (for regression) ----

### 2.a. Bootstrapping train control ----
# The "train control" allows you to specify that bootstrapping (sampling with
# replacement) can be used and also the number of times (repetitions or reps)
# the sampling with replacement should be done. The code below specifies
# bootstrapping with 500 reps. (common values for reps are thousands or tens of
# thousands depending on the hardware resources available).

# This increases the size of the training dataset from n observations to
# approximately n x 500 observations for training the model.
train_control <- trainControl(method = "boot", number = 500)

PimaIndiansDiabetes_model_lm <- # nolint
  caret::train(diabetes ~
                 preg + plas + pres + skin + insu + mass + pedi + age,
               data = PimaIndiansDiabetes_train,
               trControl = train_control,
               na.action = na.omit, method = "lm", metric = "RMSE")

## 3. Test the trained linear regression model using the testing dataset ----
predictions_lm <- predict(PimaIndiansDiabetes_model_lm, PimaIndiansDiabetes_test[, -9])

## 4. View the RMSE and the predicted values for the observations ----
print(PimaIndiansDiabetes_model_lm)
print(predictions_lm)

## 5. Use the model to make a prediction on unseen new data ----
# New data for each of the independent variables can also be specified in a data frame:
new_data <- data.frame(
  preg = 1, plas = 85, pres = 66, skin = 29, insu = 0, mass = 26.6, pedi = 0.351, age = 31,
  check.names = FALSE
)

# We now use the model to predict the output based on the unseen new data:
predictions_lm_new_data <- predict(PimaIndiansDiabetes_model_lm, new_data)

# The output refers to diabetes prediction:
print(predictions_lm_new_data)


