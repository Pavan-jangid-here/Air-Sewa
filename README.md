# **Project Name: Air-Sewa**


## Table of Content:
1. [Project Description](#project-description)
2. [Key Features](#key-features)
3. [Table and its Metadata](#table-and-its-metadata)
4. [Queries and Analysis](#queries-and-analysis)
5. [Application](#application)


## Project Description: 
The Air-Sewa Data Analysis project involves extracting, processing, and analyzing air flights data obtained from the official data portal of the Government of India, data.gov.in. The Air-Sewa initiative provides comprehensive air flight information from various monitoring stations across the country regarding grievances as well. This project focuses on leveraging SQL (Structured Query Language) to manage and analyze the dataset efficiently.


## Key Features

- Data extraction and cleaning from data.gov.in and additional tables
- Database creation and normalization
- Exploratory Data Analysis (EDA) using SQL queries
- Performance analysis of monitoring stations
- Temporal and spatial analysis of air quality patterns, flight schedules, and airport services


## Table and its Metadata
### I have used 3 Tables namely: Air_Sewa_Grievances, Flight_Schedule, Air_Sewa_Airport_Services

## Air_Sewa_Grievances Table

| Column Name                                  | Data Type |
| -------------------------------------------- | --------- |
| category                                     | TEXT      |
| subcategory                                  | TEXT      |
| type                                         | TEXT      |
| totalReceived                                | INTEGER   |
| activeGrievancesWithoutEscalation            | INTEGER   |
| activeGrievancesWithEscalation               | INTEGER   |
| closedGrievancesWithoutEscalation            | INTEGER   |
| closedGrievancesWithEscalation               | INTEGER   |
| successfulTransferIn                         | INTEGER   |
| successfulTransferOut                        | INTEGER   |
| grievancesWithoutRatings                     | INTEGER   |
| grievancesWithRatings                        | INTEGER   |
| grievancesWithVeryGoodRating                 | INTEGER   |
| grievancesWithGoodRating                     | INTEGER   |
| grievancesWithOKRating                       | INTEGER   |
| grievancesWithBadRating                      | INTEGER   |
| grievancesWithVeryBadRating                  | INTEGER   |
| twitterGrievances                            | INTEGER   |
| facebookGrievances                           | INTEGER   |
| grievancesAdditionalInfoProvided             | INTEGER   |
| grievancesAdditionalInfoNotProvided          | INTEGER   |
| grievancesWithoutFeedback                    | INTEGER   |
| grievancesWithFeedback                       | INTEGER   |
| grievancesWithFeedbackIssueNotResolved       | INTEGER   |
| grievancesWithFeedbackIssueResolved          | INTEGER   |

## Flight_Schedule Table

| Column Name               | Data Type |
| ------------------------- | --------- |
| airline                   | TEXT      |
| flightNumber              | TEXT      |
| origin                    | TEXT      |
| destination               | TEXT      |
| daysOfWeek                | TEXT      |
| scheduledDepartureTime    | TIME      |
| scheduledArrivalTime      | TIME      |
| timezone                  | TEXT      |
| validFrom                 | DATE      |
| validTo                   | DATE      |
| lastUpdated               | TIMESTAMP |

## Air_Sewa_Airport_Services Table

| Column Name       | Data Type |
| ----------------- | --------- |
| airport           | TEXT      |
| categoryenglish   | TEXT      |
| titleEnglish      | TEXT      |
| descriptionEnglish | TEXT      |
| email             | TEXT      |
| phone             | TEXT      |
| website           | TEXT      |
| last_updated      | TIMESTAMP |

## Queries and Analysis
### This is the question that I have taken for queries:

Q1. Retrieve the airline and the category with the highest percentage of grievances with very good ratings, including the rank.

Q2. Calculate the average number of grievances with feedback for each airline and category over time.

Q3. Find the total number of active grievances without escalation for each airline and flight number combination, where the scheduled departure time is between 8:00 AM and 12:00 PM.

Q4. List the airlines that have the highest number of successful transfers out and the highest number of grievances with very bad ratings.

Q5. Find the top 5 airlines with the highest number of grievances on Sundays for flights originating from 'Delhi' to 'Hyderabad.'

Q6. Calculate the average number of grievances with feedback for each airline, but only consider records that are valid within the date range '2023-01-01' to '2023-12-31.'

Q7. Find the airlines with the highest percentage of successful transfers out of the total number of grievances (with or without ratings).

Q8. List the top 3 airlines with the most grievances on Mondays between 10:00 AM and 2:00 PM, originating from 'Goa' to 'Hyderabad.'

Q9. Find the airlines that have never had a grievance with a very bad rating (grievancesWithVeryBadRating = 0) but have the highest number of grievances with good ratings.

Q10. Calculate the average number of grievances with feedback for flights scheduled on Sundays (across all airlines) between 2023-01-01 and 2023-12-31.

Q11. Find the airlines with the highest percentage of grievances with additional information provided but without feedback, out of the total number of grievances with feedback.

Q12. For each airline, calculate the percentage of grievances with very good ratings (5) out of the total number of grievances with ratings. Then, find the airlines with the highest average percentage of very good ratings.

Q13. Calculate the average time duration (in minutes) between scheduled departure and scheduled arrival times for each airline. Find the airline with the highest average time duration.

Q14. Types of services available at airports in different cities, their quantities, and list the top non-reliable service.


## Application:

1. Decision-Making: The results of these queries provide insights into different aspects of the dataset. For example, information about grievance percentages, airline performance, and service reliability can inform decision-making processes.
2. Performance Evaluation: Airlines, airports, or services can be evaluated based on various metrics, such as the number of grievances, successful transfers, or average feedback. This evaluation can be useful for identifying areas of improvement.
3. Trend Analysis: Time-related queries (e.g., grievances over time, average feedback over time) can help identify trends and patterns. This information can be valuable for understanding how certain metrics change over specific periods
4. Ranking and Benchmarking: Queries involving ranks (e.g., ranking airlines by various criteria) can be used for benchmarking and identifying leaders in specific categories. This information can be valuable for industry comparisons.
5. User Feedback: If the dataset includes user feedback or ratings, the results can provide insights into user satisfaction. This can be useful for understanding the strengths and weaknesses of airlines or services.
6. Resource Allocation: Information about grievances, successful transfers, and other metrics can guide resource allocation strategies. For example, airlines with higher grievances may need more attention or resources for improvement.
7. Operational Improvements: Results from queries related to service reliability or grievances with very bad ratings can highlight areas that need operational improvements. This information can be used to enhance the overall quality of services.
