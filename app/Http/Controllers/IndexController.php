<?php

namespace App\Http\Controllers;

use Illuminate\Contracts\View\View;
use Illuminate\Http\Request;

class IndexController extends Controller
{
    public function indexAction(Request $request): View
    {
        $data = $request->all();

        return view('index', compact('data'));
    }
}
