class ToDoApp {
    constructor() {
        this.columns = {
            new: document.getElementById("NewTasks"),
            inProcess: document.getElementById("InProcessTasks"),
            done: document.getElementById("DoneTasks"),
        };
    }

    clearAllTasks() {
        this.columns.new.innerHTML = "";
        this.columns.inProcess.innerHTML = "";
        this.columns.done.innerHTML = "";
    }
}

class Columns {

    FirstLeftButton() {
        document.getElementById("DoneTasks").appendChild(document.getElementById("NewTasks").firstChild);
    }

    FirstRightButton() {
        document.getElementById("InProcessTasks").appendChild(document.getElementById("NewTasks").firstChild);
    }

    SecondLeftButton() {
        document.getElementById("NewTasks").appendChild(document.getElementById("InProcessTasks").firstChild);
    }

    SecondRightButton() {
        document.getElementById("DoneTasks").appendChild(document.getElementById("InProcessTasks").firstChild);
    }

    ThirdLeftButton() {
        document.getElementById("InProcessTasks").appendChild(document.getElementById("DoneTasks").firstChild);
    }

    ThirdRightButton() {
        document.getElementById("NewTasks").appendChild(document.getElementById("DoneTasks").firstChild);
    }
}

class Tasks {
    
    AddTask() {
        const input = document.getElementById("input").value;
        const NewTask_list = document.getElementById("NewTasks");
        const li = document.createElement('li');
        const right_button = document.createElement('input'); right_button.type = 'button';
        const left_button = document.createElement('input'); left_button.type = 'button';
        li.addEventListener("click", function() {
            this.remove();
        })
        if (input == '') {}
        else {
            li.appendChild(document.createTextNode(input));
            li.style.backgroundColor = 'white';
            NewTask_list.appendChild(li);
        }
    }
}

const tasks = new Tasks();
const ToDoApp1 = new ToDoApp();
const columns = new Columns();

document.getElementById('button').addEventListener('click', function() {
    tasks.AddTask();
})

document.getElementById("delete-button").addEventListener('click', function() {
    ToDoApp1.clearAllTasks();
})

document.getElementById("name1_left_button").addEventListener('click', function() {
    columns.FirstLeftButton();
})

document.getElementById("name1_right_button").addEventListener('click', function() {
    columns.FirstRightButton();
})

document.getElementById("name2_left_button").addEventListener('click', function() {
    columns.SecondLeftButton();
})

document.getElementById("name2_right_button").addEventListener('click', function() {
    columns.SecondRightButton();
})

document.getElementById("name3_left_button").addEventListener('click', function() {
    columns.ThirdLeftButton();
})

document.getElementById("name3_right_button").addEventListener('click', function() {
    columns.ThirdRightButton();
})