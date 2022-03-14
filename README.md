[From First-Touch to Multi-Touch Attribution With RudderStack, Dbt, and SageMaker](https://www.rudderstack.com/blog/from-first-touch-to-multi-touch-attribution-with-rudderstack-dbt-and-sagemaker/)

In this repo, we clean the data in the warehouse using dbt to create the input data for the Multi-touch attribution modeling. This is a template project which needs to be modified as per your data format.    This repo produces a series of user touches (page, track and identify calls).  If your project is solely focused on marketing attribution, change the track and page calls to be the campaign, channel, etc. to fit your design.

### Before you Begin, please take a look at the following:

dbt_project.yml (https://github.com/rudderlabs/dbt-attribution-template/blob/main/dbt_project.yml)
  - Understand the role of generic domains.  If you are aggregating at the account level, this is critical.  If you are a B2C company and want to run the model at the individual email level, set all domains to be generic
  - Consolidate Page Calls.  If you have a large site, focus page calls on relevant touches on your website and consolidate others into an "Other" option
  - Exclude Redundant Or Irrelevant Track Calls.  You may have track calls that are not at all applicable or redundant in your process.  Perhaps a client side and a server side event that mean the same thing.  You may want to ignore one or the other since these represent the same action.



### Running dbt project:

Try running the following commands:
- dbt run
- dbt test


### DBT Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](http://community.getbdt.com/) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
