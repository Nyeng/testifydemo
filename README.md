#### (Forked repo from Browserstack/Capybara)


* Hassle free startup guide: http://www.swtestacademy.com/ruby-cucumber-and-capybara-on-windows/ (use this for installing ruby environment)

* When receiving SSL error on Ruby gems
Setup Ruby Windows:
http://guides.rubygems.org/ssl-certificate-update/



## Setup
* Clone the repo
* Install dependencies `bundle install`
* Update `*.config.yml` files inside the `config/` directory with your [BrowserStack Username and Access Key](https://www.browserstack.com/accounts/settings)

### Running tests
* To run a single test, run `bundle exec rake single`
* To run parallel tests, run `bundle exec rake parallel`
* To run local tests, run `bundle exec rake local`
* To simply run cucumber `cucumber features/feature_file.feature`
* To run with browserstack `cucumber features/feature_file.feature BROWSERSTACK=true
* To run tests in parallel `parallel_cucumber features`


## Notes
* You can view your test results on the [BrowserStack Automate dashboard](https://www.browserstack.com/automate)
* To test on a different set of browsers, check out our [platform configurator](https://www.browserstack.com/automate/ruby#setting-os-and-browser)
* You can export the environment variables for the Username and Access Key of your BrowserStack account
  
  ```
  export BROWSERSTACK_USERNAME=<browserstack-username> &&
  export BROWSERSTACK_ACCESS_KEY=<browserstack-access-key>
  ```
