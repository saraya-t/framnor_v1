# Framnor

## Survey

<https://docs.google.com/forms/d/e/1FAIpQLSd51QpOFdaLQ5kzW4nRPEfWm1aiD09Zb_ZE6DCJVJqaIlGZJg/viewform>

### Survey data

Original copy: /data-raw/Copy of Norsk\_Farm questionnaire
survey\_24.06.2021\_for testing (Responses).xlsx

Current version used in the application:
/input/questionnaire\_survey\_sample\_20210823.xlsx

Live data will be integrated later.

## Analysis

The calculations for growout and onland hatchery are the same it’s just
different data that goes in:

-   /R/calculate\_stats : Calculations for both growout and onland
    hatchery
-   /input/set\_stat\_table\_growout.R : This script generates 4 tables
    in the /input directory with groups information and weights
-   /input/set\_stat\_table\_onland\_hatchery.R : This script generates
    4 tables in the /input directory with groups information and weights

Margarida’s original analysis files are:

-   /R/archive/growout.R
-   /R/archive/onland-hatchery.R

## Design/Layout

See the pptx files in /www/app\_design.
