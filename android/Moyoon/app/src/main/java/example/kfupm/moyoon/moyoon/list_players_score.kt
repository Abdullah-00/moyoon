package example.kfupm.moyoon.moyoon

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.TextView






    class list_players_score(var  cont: Context, var resorce:Int,
                     var item: ArrayList<String>): ArrayAdapter<String>(cont,resorce,item) {


        override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
            val layoutInflater: LayoutInflater = LayoutInflater.from(context)

            val view: View = layoutInflater.inflate(resorce, null)

            val btn: TextView = view.findViewById(R.id.names_scores)

            val answer: String = item[position]
            btn.text = answer
            return view

        }




    }
