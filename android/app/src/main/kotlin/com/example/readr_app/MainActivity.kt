package com.example.readr_app

import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onNewIntent(@NonNull intent : Intent){
        var uri: String? = intent.data?.toString()
        if (uri != null && 
            (uri!!.startsWith("https://mirrormedia.onelink.me") || uri!!.startsWith("https://mirrormediadev.onelink.me") )
        ) {
            setIntent(intent)
        } else {
            super.onNewIntent(intent)
        }
    }
}