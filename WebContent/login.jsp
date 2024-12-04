<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Screen</title>
    <script src="https://cdn.tailwindcss.com"></script> <!-- Include Tailwind CSS -->
      <!-- Font Awesome CDN for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
</head>
<body class="font-sans bg-white">
<!-- Back Button -->
    <a href="index.jsp" class="absolute top-4 left-4 bg-slate-900 text-white p-2 rounded-full shadow-md hover:bg-slate-800 focus:outline-none focus:ring-2 focus:ring-slate-600">
        <i class="fas fa-arrow-left"></i> <!-- Font Awesome Back Arrow Icon -->
    </a>

    <!-- Navbar Placeholder -->
    <nav class="bg-white border-gray-200 dark:bg-gray-900">
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
                </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="min-h-screen flex flex-col items-center justify-center py-6 px-4">
        <div class="grid md:grid-cols-2 items-center gap-4 max-w-6xl w-full">
            
            <!-- Login Form Section -->
            <div class="border border-gray-300 rounded-lg p-6 max-w-md shadow-lg max-md:mx-auto">
                <form class="space-y-4" method="post" action="validateLogin.jsp">

                    <!-- Title and Description -->
                    <div class="mb-8">
                        <h3 class="text-gray-800 text-3xl font-extrabold">Sign in</h3>
                        <p class="text-gray-500 text-sm mt-4 leading-relaxed">Sign in to your account and explore a world of possibilities. Your journey begins here.</p>
                    </div>

                    <!-- Error Message Display (from session) -->
                    <%
                    // Only show error message if a login attempt has been made and it failed
                    String loginMessage = (String) session.getAttribute("loginMessage");
                    if (loginMessage != null) {
                        out.println("<p class='text-red-500 text-sm mt-2'>" + loginMessage + "</p>");
                        // Remove the login message after displaying it
                        session.removeAttribute("loginMessage");
                    }
                    %>

                    <!-- Username Input -->
                    <div>
                        <label class="text-gray-800 text-sm mb-2 block">User name</label>
                        <div class="relative flex items-center">
                            <input name="username" type="text" required class="w-full text-sm text-gray-800 border border-gray-300 px-4 py-3 rounded-lg outline-blue-600" placeholder="Enter user name" />
                            <svg xmlns="http://www.w3.org/2000/svg" fill="#bbb" stroke="#bbb" class="w-[18px] h-[18px] absolute right-4" viewBox="0 0 24 24">
                                <circle cx="10" cy="7" r="6" data-original="#000000"></circle>
                                <path d="M14 15H6a5 5 0 0 0-5 5 3 3 0 0 0 3 3h12a3 3 0 0 0 3-3 5 5 0 0 0-5-5zm8-4h-2.59l.3-.29a1 1 0 0 0-1.42-1.42l-2 2a1 1 0 0 0 0 1.42l2 2a1 1 0 0 0 1.42 0 1 1 0 0 0 0-1.42l-.3-.29H22a1 1 0 0 0 0-2z" data-original="#000000"></path>
                            </svg>
                        </div>
                    </div>

                    <!-- Password Input -->
                    <div>
                        <label class="text-gray-800 text-sm mb-2 block">Password</label>
                        <div class="relative flex items-center">
                            <input name="password" type="password" required class="w-full text-sm text-gray-800 border border-gray-300 px-4 py-3 rounded-lg outline-blue-600" placeholder="Enter password" />
                            <svg xmlns="http://www.w3.org/2000/svg" fill="#bbb" stroke="#bbb" class="w-[18px] h-[18px] absolute right-4 cursor-pointer" viewBox="0 0 128 128">
                                <path d="M64 104C22.127 104 1.367 67.496.504 65.943a4 4 0 0 1 0-3.887C1.367 60.504 22.127 24 64 24s62.633 36.504 63.496 38.057a4 4 0 0 1 0 3.887C126.633 67.496 105.873 104 64 104zM8.707 63.994C13.465 71.205 32.146 96 64 96c31.955 0 50.553-24.775 55.293-31.994C114.535 56.795 95.854 32 64 32 32.045 32 13.447 56.775 8.707 63.994zM64 88c-13.234 0-24-10.766-24-24s10.766-24 24-24 24 10.766 24 24-10.766 24-24 24zm0-40c-8.822 0-16 7.178-16 16s7.178 16 16 16 16-7.178 16-16-7.178-16-16-16z" data-original="#000000"></path>
                            </svg>
                        </div>
                    </div>

                    <!-- Remember Me and Forgot Password -->
                    <div class="flex flex-wrap items-center justify-between gap-4">
                        <div class="flex items-center">
                            <input id="remember-me" name="remember-me" type="checkbox" class="h-4 w-4 shrink-0 text-blue-600 focus:ring-blue-500 border-gray-300 rounded" />
                            <label for="remember-me" class="ml-3 block text-sm text-gray-800">Remember me</label>
                        </div>

                        <div class="text-sm">
                            <a href="javascript:void(0);" class="text-blue-600 hover:underline font-semibold">Forgot your password?</a>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <div class="!mt-8">
                        <button type="submit" class="w-full shadow-xl py-3 px-4 text-sm tracking-wide rounded-lg text-white bg-blue-600 hover:bg-blue-700 focus:outline-none">Log in</button>
                    </div>

                    <!-- Register Link -->
                    <p class="text-sm !mt-8 text-center text-gray-800">Don't have an account 
                        <a href="register.jsp" class="text-blue-600 font-semibold hover:underline ml-1 whitespace-nowrap">Register here</a>
                    </p>
                </form>
            </div>

            <!-- Image Section -->
            <div class="lg:h-[400px] md:h-[300px] max-md:mt-8">
                <img src="https://readymadeui.com/login-image.webp" class="w-full h-full max-md:w-4/5 mx-auto block object-cover" alt="Login Illustration" />
            </div>
        </div>
    </div>

</body>
</html>
