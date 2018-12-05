package example.kfupm.moyoon.moyoon

import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.View.inflate
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.BaseAdapter
import android.widget.Button
import android.widget.TextView

class list_names(var  cont: Context, var resorce:Int,
                          var item: ArrayList<String>):ArrayAdapter<String>(cont,resorce,item) {


    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val layoutInflater: LayoutInflater = LayoutInflater.from(context)

        val view: View = layoutInflater.inflate(resorce, null)

        val btn: TextView = view.findViewById(R.id.names)

        val answer: String = item[position]
        btn.text = answer
        return view

    }




}