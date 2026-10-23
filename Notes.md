Flutter & Code Formatting
Dart comes with a code formatter which - for example when using VS Code - will cause your code to be auto-formatted to be more readable.

Since Dart 3.7.0 the code formatter has changed slightly (compared to what you see in the course videos).

→ The code formatter will now remove the final comma and put code onto one line, if it fits the configured line width. This is not a significant change and does NOT affect how the code execute.

Important: You can change this (back to what you see in the videos)!

To do that, edit (if they file already exists) or add a new file analysis_options.yaml in your Flutter project.

On the outermost indentation level, add the following configuration:

```yaml

# This file configures the analyzer, which statically analyzes Dart code to
# check for errors, warnings, and lints.
#
# The issues identified by the analyzer are surfaced in the UI of Dart-enabled
# IDEs (https://dart.dev/tools#ides-and-editors). The analyzer can also be
# invoked from the command line by running `flutter analyze`.
 
# The following line activates a set of recommended lints for Flutter apps,
# packages, and plugins designed to encourage good coding practices.
include: package:flutter_lints/flutter.yaml
 
formatter: 
  trailing_commas: preserve
 
linter:
  # The lint rules applied to this project can be customized in the
  # section below to disable rules from the `package:flutter_lints/flutter.yaml`
  # included above or to enable additional rules. A list of all available lints
  # and their documentation is published at https://dart.dev/lints.
  #
  # Instead of disabling a lint rule for the entire project in the
  # section below, it can also be suppressed for a single line of code
  # or a specific dart file by using the `// ignore: name_of_lint` and
  # `// ignore_for_file: name_of_lint` syntax on the line or in the file
  # producing the lint.
  rules:
    # avoid_print: false  # Uncomment to disable the `avoid_print` rule
    # prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule
 
# Additional information about this file can be found at
# https://dart.dev/guides/language/analysis-options


```


## Creating custom widget 

1) if you dont have any internal data that changes the UI extend StatelessWidget

2) if you internal data that changes the UI extend StatefulWidget and create a private class with same name as the widget class appended by the name State i.e (YourWidgetNameState) but with an underscore (_) in front of it and extend State<YourWidgetNameState>.


## Lifting the stateup 

- one common widget renders multiple screens based on conditinal widget rendered. In this case, the state of the widget is lifted up to the parent widget and passed down to the child widgets as a parameter.


## StatefulWidget LifeCycle

Deep Dive: Flutter's (Stateful) Widget Lifecycle
Every Flutter Widget has a built-in lifecycle: A collection of methods that are automatically executed by Flutter (at certain points of time).

There are three extremely important (stateful) widget lifecycle methods you should be aware of:

initState(): Executed by Flutter when the StatefulWidget's State object is initialized

build(): Executed by Flutter when the Widget is built for the first time AND after setState() was called

dispose(): Executed by Flutter right before the Widget will be deleted (e.g., because it was displayed conditionally)

## if in lists 

Using "if" Statements In Lists
The if statement is a crucial feature of the Dart language - actually, it's a core feature of pretty much all programming languages.

In addition to what you learned in the previous lecture, in Dart, you may also use if inside of lists to conditionally add items to lists:

final myList = [
  1,
  2,
  if (condition)
    3
];
In this example, the number 3 will only be added to myList if condition was met (condition can be true or false or a check that yields true or false - e.g., day == 'Sunday').

Please note that there are NO curly braces around the if statement body. The if statement body also only comprises the next line of code (i.e., you can't have multiple lines of code inside the if statement).

You can also specify an else case - an alternative value that may be inserted into the list if condition is not met:

final myList = [
  1,
  2,
  if (condition)
    3
  else
    4
];
Using this feature is optional. Alternatively, you could, for example, also work with a ternary expression:

final myList = [
  1,
  2,
  condition ? 3 : 4
];
Especially when inserting more complex values (e.g., a widget with multiple parameters being set) into a more complex list (e.g., a list of widgets passed to a Column() or Row()), this feature can lead to more readable code.




https://github.com/dart-lang/language/blob/master/accepted/2.3/control-flow-collections/feature-specification.md