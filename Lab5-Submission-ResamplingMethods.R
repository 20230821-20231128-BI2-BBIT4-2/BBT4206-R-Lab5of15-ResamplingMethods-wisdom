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


