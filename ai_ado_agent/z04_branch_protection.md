# outof 7 groups currently active groups are
1. Ai-Projects Team
2. Project Administrators 
3. Contributors

- Development Environment
```sh
AI-Project--> Repos --> branchs --> develop --> branch policies
```
| Setting                                                          | Recommended                              |
| ---------------------------------------------------------------- | -----------------------------------------|
| Minimum number of reviewers                                      | **1**                                    |
| Allow requestors to approve their own changes                    | **Uncheck**                              |
| Prohibit the most recent pusher from approving their own changes | **Enable**                               |
| Allow completion even if some reviewers vote to wait or reject   | **Uncheck**                              |
| When new changes are pushed                                      | **Require 1 approval on every iteration**|
| Check for linked work items                                      | **Required**                             |
| Check for comment resolution                                     | **Required**                             |
| Squash Merge                                                     | **Enable**                               |
| Basic Merge                                                      | **Uncheck**                              |
| Rebase and Fast Forward                                          | **Uncheck**                              |
| Rebase with Merge Commit                                         | **Uncheck**                              |

- Production Enviornment
| Setting                                                          | Recommended                                |
| ---------------------------------------------------------------- | ------------------------------------------ |
| Minimum number of reviewers                                      | **2**                                      |
| Allow requestors to approve their own changes                    | **Uncheck**                                |
| Prohibit the most recent pusher from approving their own changes | **Enable**                                 |
| Allow completion even if some reviewers vote to wait or reject   | **Uncheck**                                |
| When new changes are pushed                                      | **Require 2 approvals on every iteration** |
| Check for linked work items                                      | **Required**                               |
| Check for comment resolution                                     | **Required**                               |
| Build Validation                                                 | **Required**                               |
| Automatically include code reviewers                             | **Optional (Recommended)**                 |
| Squash Merge                                                     | **Enable**                                 |
| Basic Merge                                                      | **Uncheck**                                |
| Rebase and Fast Forward                                          | **Uncheck**                                |
| Rebase with Merge Commit                                         | **Uncheck**                                |

- develop/main Branch → Security → Contributors
| Permission                                    | Recommended |
| --------------------------------------------- | ----------- |
| Bypass policies when completing pull requests | **Deny**    |
| Bypass policies when pushing                  | **Deny**    |
| Contribute                                    | **Allow**   |
| Edit policies                                 | **Not set** |
| Force push                                    | **Deny**    |
| Manage permissions                            | **Not set** |
| Remove others' locks                          | **Not set** |

- develop/main Branch → Security → Build Administrators
| Permission                                    | Recommended |
| --------------------------------------------- | ----------- |
| Bypass policies when completing pull requests | **Deny**    |
| Bypass policies when pushing                  | **Deny**    |
| Contribute                                    | **Allow**   |
| Edit policies                                 | **Not set** |
| Force push                                    | **Deny**    |
| Manage permissions                            | **Not set** |
| Remove others' locks                          | **Not set** |

inlogic_ai_test_suite_fe
inlogic_ai_test_suite_be
inlogic_ai_langfuse
inlogic_ai_ccd_intelligence_fe
inlogic_ai_Ccd_intelligence_be