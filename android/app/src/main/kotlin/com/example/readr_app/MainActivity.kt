package com.example.readr_app

import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    // TODO: need to fix
    // This can fix an appsflyer feature.
    // Trigger the event from appOpenAttributionStream after 
    // opening the deep link when app is working in the background.
    // But it will cause another problem that 
    // firebase cloud message can not trigger the onResume function 
    // when app is working in the background.
    // So I comment this temporarily.
    // override fun onNewIntent(@NonNull intent : Intent){
    //     setIntent(intent)
    // }
}