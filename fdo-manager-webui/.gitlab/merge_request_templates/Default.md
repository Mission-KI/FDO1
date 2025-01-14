# Summary

*Insert a meaningful description for this merge request here:  What is the new/changed behavior?
Which bug has been fixed? Are there related issues?*


# Focus

*Point the reviewer to the core of the code change. Where should they start reading? What should
they focus on (e.g. security, performance, maintainability, user-friendliness, compliance with the
specs, finding more corner cases, concrete questions)?*


# Test Environment

*How to set up a test environment for manual testing?*


# Check List for the Author

Please, prepare your MR for a review. Be sure to write a summary and a focus and create gitlab
comments for the reviewer. They should guide the reviewer through the changes, explain your changes
and also point out open questions. For further good practices have a look at [our review
guidelines](https://gitlab.com/caosdb/caosdb/-/blob/dev/REVIEW_GUIDELINES.md)

- [ ] All automated tests pass
- [ ] Reference related issues
- [ ] Up-to-date CHANGELOG.md (or not necessary)
- [ ] Up-to-date JSON schema (or not necessary)
- [ ] Appropriate user and developer documentation (or not necessary)
  - Update / write published documentation (`make doc`).
  - How do I use the software?  Assume "stupid" users.
  - How do I develop or debug the software?  Assume novice developers.
- [ ] Annotations in code (Gitlab comments)
  - Intent of new code
  - Problems with old code
  - Why this implementation?


# Check List for the Reviewer

- [ ] I understand the intent of this MR
- [ ] All automated tests pass
- [ ] Up-to-date CHANGELOG.md (or not necessary)
- [ ] Appropriate user and developer documentation (or not necessary), also in published
      documentation.
- [ ] The test environment setup works and the intended behavior is reproducible in the test
  environment
- [ ] In-code documentation and comments are up-to-date.
- [ ] Check: Are there specifications? Are they satisfied?

For further good practices have a look at [our review guidelines](https://gitlab.com/caosdb/caosdb/-/blob/dev/REVIEW_GUIDELINES.md).


/assign me
/target_branch dev
