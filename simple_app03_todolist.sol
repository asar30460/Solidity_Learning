// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TodoList {
    struct Todo {
        string text;
        bool completed;
    }

    Todo[] public todos;

    function create(string calldata _text) external {
        todos.push(Todo({text: _text, completed: false}));
    }

    function updateText(uint8 _index, string calldata _text) external{
        // This way consume more gas since access array each time to update.
        todos[_index].text = _text;

        // Another way to update.
        /*
        Todo storage todo = todos[_index];
        todo.text = _text;
        */
    }

    function get(uint8 _index) external view returns (string memory, bool) {
        Todo memory todo = todos[_index];
        return(todo.text, todo.completed);
    }

    function toggleCompleted(uint _index) external {
        todos[_index].completed = !todos[_index].completed;
    }
}
