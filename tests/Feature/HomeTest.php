<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Http\Response;
use Tests\TestCase;

class HomeTest extends TestCase
{
    public function testRouteDefaultWeb()
    {
        $this->getJson('/')
             ->assertStatus(Response::HTTP_OK);
    }

    public function testRouteDefaultApi()
    {
        $this->getJson('/')
             ->assertStatus(Response::HTTP_OK);
    }
}
