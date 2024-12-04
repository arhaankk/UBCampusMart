<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UBCampusMart Main Page</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome CDN -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background-image: url('bg.jpg');
            background-attachment: scroll; /* Allows the background to scroll */
            background-size: cover; /* Ensures the image covers the viewport */
            background-repeat: no-repeat; /* Prevents tiling */
        }

        /* Keyframes for typewriter effect */
        @keyframes typing {
            0% {
                width: 0;
            }
            100% {
                width: 100%;
            }
        }



        /* Change navbar background color */
        nav {
            background-color: #090b2b; /* Dark blue color */
        }

        /* Ensure all text on the navbar is white */
        nav a,
        nav button,
        nav span {
            color: white !important; /* Overrides any existing color */
        }

        /* Change all black text to white */
        .text-gray-900 {
            color: white !important;
        }

        /* Optional: Hover effects */
        nav a:hover,
        nav button:hover {
            color: #CCCCCC; /* Light gray for hover effect */
        }

        /* Apply the typing effect to the element */
        .animate-typing {
            display: inline-block;
            white-space: nowrap;
            overflow: hidden;
            border-right: 4px solid white; /* Cursor-like effect */
            animation: typing 3s steps(30) 1s 1 normal both; /* Adjust time and steps to match your text */
        }

        /* Optional: Add blinking cursor effect */
        @keyframes blink {
            50% {
                border-color: transparent;
            }
        }

        .animate-typing {
            animation: typing 3s steps(30) 1s 1 normal both, blink 0.75s step-end infinite;
        }

        /* Style for the image and quote section */
        .content-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
            margin-top: 50px;
        }

        .quote {
            color: skyblue;
            font-size: 1.5rem;
            font-style: italic;
            max-width: 500px;
        }

        .image {
            max-width: 400px;
            max-height: 400px;
        }
    </style>
</head>
<body class="bg-gray-100 text-gray-800 font-sans m-0 p-0">

    <!-- Navbar -->
    <nav class="border-gray-200">
        <div class="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-4">
            <a href="http://localhost/shop/index.jsp" class="flex items-center space-x-3 rtl:space-x-reverse">
                <span class="self-center text-2xl font-semibold whitespace-nowrap dark:text-white">UBCampusMart</span>
            </a>
            <button data-collapse-toggle="navbar-default" type="button" class="inline-flex items-center p-2 w-10 h-10 justify-center text-sm text-gray-500 rounded-lg md:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600" aria-controls="navbar-default" aria-expanded="false">
                <span class="sr-only">Open main menu</span>
                <svg class="w-5 h-5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 17 14">
                    <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M1 1h15M1 7h15M1 13h15"/>
                </svg>
            </button>
            <div class="hidden w-full md:block md:w-auto" id="navbar-default">
                <ul class="font-medium flex flex-col p-4 md:p-0 mt-4 border border-gray-100 rounded-lg bg-gray-50 md:flex-row md:space-x-8 rtl:space-x-reverse md:mt-0 md:border-0 md:bg-white dark:bg-gray-800 md:dark:bg-gray-900 dark:border-gray-700">
                    <li>
                        <%
                            String firstName = (String) session.getAttribute("authenticatedUser"); 
                            boolean isLoggedIn = (firstName != null && !firstName.isEmpty());
                        %>
                        <a href="<%= isLoggedIn ? "listprod.jsp" : "login.jsp" %>" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">
                            Begin Shopping
                        </a>
                    </li>
                    <li>
                        <a href="admin.jsp" class="block py-2 px-3 text-gray-900 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-white md:dark:hover:text-blue-500 dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent">Administrators</a>
                    </li>
                    <li>
                        <button id="dropdownNavbarLink" data-dropdown-toggle="dropdownNavbar" class="flex items-center justify-between w-full py-2 px-3 text-gray-900 hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 md:w-auto dark:text-white md:dark:hover:text-blue-500 dark:focus:text-white dark:hover:bg-gray-700 md:dark:hover:bg-transparent">
                            Account
                            <svg class="w-2.5 h-2.5 ms-2.5" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 10 6">
                                <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="m1 1 4 4 4-4"/>
                            </svg>
                        </button>
                        <!-- Dropdown menu -->
                        <div id="dropdownNavbar" class="absolute z-10 hidden font-normal bg-white divide-y divide-gray-100 rounded-lg shadow w-44 dark:bg-gray-700 dark:divide-gray-600">
                            <ul class="py-2 text-sm text-gray-700 dark:text-gray-200" aria-labelledby="dropdownLargeButton">
                                <li>
                                    <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white">Sign In</a>
                                </li>
                                <li>
                                    <a href="#" class="block px-4 py-2 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white">Profile</a>
                                </li>
                            </ul>
                            <div class="py-1">
                                <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 dark:text-gray-200 dark:hover:text-white">Sign out</a>
                            </div>
                        </div>
                    </li>

                </ul>
            </div>
        </div>
    </nav>

    <div>
        <h1 class="animate-typing overflow-hidden whitespace-nowrap border-r-4 border-r-white pr-5 text-4xl text-gray-900 font-bold mt-12 ml-4">
            <% if (isLoggedIn) { %>
                Welcome to UBCampusMart, <%= firstName %>
            <% } else { %>
                Welcome to UBCampusMart
            <% } %>
        </h1>
    </div>
<div class="content-container flex justify-between items-center mt-8 px-8">
    <!-- Quote Section (Left) -->
    <div class="quote w-1/2 text-left text-4xl text-sky-400 font-semibold ml-10">
        "UBCampus Mart: A Marketplace for Students, by Students—Safe, Simple, and Student-Centered!"
    </div>
    
    <!-- Image Section (Right) -->
    <img src="download.png" alt="UBCampusMart" class="w-2/4 md:w-2/5 mr-16"/>
</div>

<!-- Begin Shopping Button Section -->
<div class="ml-20 mt-[-120px] mb-20">
    <a href="listprod.jsp" class="bg-sky-400 text-white font-semibold py-3 px-6 rounded-md hover:bg-sky-500 transition duration-300">
        Begin Shopping
    </a>
</div>


<div class="about-us mt-72 px-8 py-16 flex justify-end mb-20">
    <div class="text-right">
        <h2 class="text-4xl text-sky-400 font-semibold mb-6">About Us</h2>
        <p class="text-2xl text-gray-300 max-w-3xl mx-auto">
            "UBCampus Mart is the marketplace designed specifically for UBC students, by UBC students. We aim to create a trusted space where students can buy, sell, and trade items with ease, knowing they are dealing with their peers. Whether it’s textbooks, electronics, or furniture, UBCampus Mart is built to foster safe, secure, and straightforward transactions within the UBC community. With verified student accounts, secure messaging, and an easy-to-use interface, we prioritize the safety and convenience of every transaction, making it the go-to marketplace for UBC students."
        </p>
    </div>
</div>

<!-- Footer -->
    <footer class="bg text-white text-center py-4">
        &copy; 2024 UBCampusMart. All rights reserved.
    </footer>


    <script>
        // JavaScript to toggle dropdown visibility
        document.getElementById("dropdownNavbarLink").addEventListener("click", function () {
            document.getElementById("dropdownNavbar").classList.toggle("hidden");
        });

        // Adding navigation behavior
        document.querySelectorAll("#dropdownNavbar a").forEach(link => {
            link.addEventListener("click", function (event) {
                const action = event.target.textContent.trim();
                if (action === "Sign In") {
                    window.location.href = "login.jsp";
                } else if (action === "Profile") {
                    window.location.href = "customer.jsp";
                } else if (action === "Sign out") {
                    window.location.href = "logout.jsp";
                }
            });
        });
    </script>

</body>
</html>
