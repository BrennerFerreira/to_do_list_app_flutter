# Lista de Tarefas (To Do List)

This is the first app I develop. It is meant to be simple yet useful for the users. I studied Python for Data Science, but this is my first software development experience. I discovered Flutter in September 2020 and it inspired me to follow a software development career. I started studying it in October of the same year and decided to create an app of my own. The first version of this app was realeased in January 2021 and contains its basic features described below.

As stated before, this app is meant to be simple, so I chose not to use any external package or plugin for state management. Everything is done with stateful widgets and setState. I chose this to really grasp the basic concepts before diving in more complex state management options.

This app uses two main external packages: sqflite (1.3.2+1) and shared_preferences (0.5.12+4). They are used to manage stored tasks and user settings.

## Features

The app has two screens:

### List Screen

It shows all tasks user saved as a list. The user has the option to insert a new task, with a title and a color, edit or delete an existing task. They can also delete all tasks marked as done with the pop up menu at the top.

When the user taps on a tile, it inverts its done status and reorganize the list. The tasks are automatically grouped first by their done status and then by their colors.

### Settings Screen

In this screen, the user can change their preferred primary color for the app and if they want to get a warning when asking to delete a single task or all tasks marked as done.

There are plans to add an option to change the app language in the future.