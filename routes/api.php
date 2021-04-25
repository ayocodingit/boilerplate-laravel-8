<?php

use App\Http\Controllers\Auth\PassportController;
use App\Http\Controllers\HomeController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::get('/', HomeController::class);

Route::post('login', [PassportController::class, 'login']);
Route::post('register', [PassportController::class, 'register']);

Route::middleware('auth:api')->group(function () {
    Route::get('logout', [PassportController::class, 'logout']);
    Route::get('user', [PassportController::class, 'show']);
});
