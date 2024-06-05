document.getElementById("changeColorButton").addEventListener("click", function() {
    document.body.style.backgroundColor = getRandomColor();
});

function getRandomColor() {
    var letters = "0123456789ABCDEF";
    var color = "#";
    for (var i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}

document.getElementById("userForm").addEventListener("submit", function(event) {
    event.preventDefault();
    const username = document.getElementById("username").value;
    const email = document.getElementById("email").value;

    fetch('http://internal.santiagosandrini.com.ar/users/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ username, email })
    })
    .then(response => {
        if (!response.ok) {
            if (response.status >= 400 && response.status < 500) {
                return response.json().then(errorData => {
                    throw new Error(`Client error: ${errorData.message}`);
                });
            } else {
                throw new Error('Server error');
            }
        }
        return response.json();
    })
    .then(data => {
        alert('User created successfully!');
        document.getElementById("userForm").reset();
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Failed to create user.');
    });
});

document.getElementById("getUsersButton").addEventListener("click", function() {
    fetch('http://internal.santiagosandrini.com.ar/users/')
    .then(response => response.json())
    .then(users => {
        const userList = document.getElementById("userList");
        userList.innerHTML = '';
        users.forEach(user => {
            const li = document.createElement("li");
            li.textContent = `Username: ${user.username}, Email: ${user.email}`;
            userList.appendChild(li);
        });
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Failed to retrieve users.');
    });
});
