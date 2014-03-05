%modules = ( # path to module name map
);
%moduleheaders = ( # restrict the module headers to those found in relative path
);
# Module dependencies.
# Every module that is required to build this module should have one entry.
# Each of the module version specifiers can take one of the following values:
#   - A specific Git revision.
#   - any git symbolic ref resolvable from the module's repository (e.g. "refs/heads/master" to track master branch)
#   - an empty string to use the same branch under test (dependencies will become "refs/heads/master" if we are in the master branch)
#
%dependencies = (
    "qtbase" => "ca4b9f624a41aa656e1d336ea48ec50fe53fa17e",
    "qtdeclarative" => "75b191b31d9936b134ca9776f1e69e891d03be11",
    "qtxmlpatterns" => "",
);
