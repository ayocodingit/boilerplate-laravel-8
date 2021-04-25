<?php

namespace Tests\Feature\Auth;

use Database\Factories\UserFactory;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Http\Response;
use Tests\TestCase;

class PassportTest extends TestCase
{
    use RefreshDatabase;
    use WithFaker;

    public function testRegister()
    {
        $data = [
            'name' => $this->faker->name(),
            'email' => $this->faker->unique()->safeEmail(),
            'email_verified_at' => now()->toDateTimeString(),
            'password' => 'password', // password
            'password_confirmation' => 'password', // password
        ];

        $this->postJson('/api/register', $data)
             ->assertStatus(Response::HTTP_CREATED);
        unset($data['password_confirmation']);
        unset($data['password']);
        $this->assertDatabaseHas('users', $data);
    }

    public function testLogin()
    {
        $this->artisan('passport:install');
        $data = (new UserFactory)->create(['password' => 'password']);

        $dataLogin = [
            'email' => $data->email,
            'password' => 'password'
        ];

        $this->postJson('/api/login', $dataLogin)
             ->assertStatus(Response::HTTP_OK)
             ->assertJsonStructure(['access_token', 'token_type', 'expires_at']);
    }

    public function testLoginInvalid()
    {
        $this->artisan('passport:install');
        $data = (new UserFactory)->create(['password' => 'password']);

        $dataLogin = [
            'email' => $data->email,
            'password' => $data->password
        ];

        $this->postJson('/api/login', $dataLogin)
             ->assertStatus(Response::HTTP_UNAUTHORIZED)
             ->assertJsonStructure(['error']);
    }

    public function testShow()
    {
        $this->artisan('passport:install');
        $data = (new UserFactory)->create(['password' => 'password']);

        $dataLogin = [
            'email' => $data->email,
            'password' => 'password'
        ];

        $user = $this->postJson('/api/login', $dataLogin)->getContent();
        $accessToken = json_decode($user)->access_token;

        $headers = [
            'Authorization' => "Bearer $accessToken"
        ];
        $this->getJson('/api/profile', $headers)
             ->assertStatus(Response::HTTP_OK);

    }

    public function testTokenInvalid()
    {
        $this->artisan('passport:install');
        $data = (new UserFactory)->create(['password' => 'password']);

        $dataLogin = [
            'email' => $data->email,
            'password' => 'password'
        ];

        $user = $this->postJson('/api/login', $dataLogin)->getContent();
        $accessToken = json_decode($user)->access_token;

        $headers = [
            'Authorization' => "Bearers $accessToken"
        ];
        $this->getJson('/api/profile', $headers)
             ->assertStatus(Response::HTTP_UNAUTHORIZED);

    }

    public function testLogout()
    {
        $this->artisan('passport:install');
        $data = (new UserFactory)->create(['password' => 'password']);

        $dataLogin = [
            'email' => $data->email,
            'password' => 'password'
        ];

        $user = $this->postJson('/api/login', $dataLogin)->getContent();
        $accessToken = json_decode($user)->access_token;

        $headers = [
            'Authorization' => "Bearer $accessToken"
        ];
        $this->getJson('/api/logout', $headers)
             ->assertStatus(Response::HTTP_OK);

    }
}
