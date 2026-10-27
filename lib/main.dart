
import 'package:flutter/material.dart';
void main()=>runApp(const CatatanKuApp());

const navy=Color(0xFF0F2D5C);
const gold=Color(0xFFFFC928);

class CatatanKuApp extends StatelessWidget{
  const CatatanKuApp({super.key});
  @override
  Widget build(BuildContext c){
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title:"CatatanKu",
      theme:ThemeData(
        useMaterial3:true,
        colorScheme:ColorScheme.fromSeed(seedColor:navy),
        scaffoldBackgroundColor:Colors.white
      ),
      home:const SplashPage(),
    );
  }
}

class Note{
  String title,body,category,priority,date;
  Color color;
  Note(this.title,this.body,this.category,this.priority,this.date,this.color);
}

final notes=<Note>[
  Note("Ide Aplikasi","Membuat aplikasi CatatanKu dengan Flutter.","Pribadi","Penting","19 Oktober 2026",const Color(0xFFFFF3C4)),
  Note("Rencana Mingguan","Mengerjakan tugas Flutter.","Kuliah","Sedang","18 Oktober 2026",const Color(0xFFE9F4FF)),
  Note("Belanja","Beli buku dan pulpen.","Pribadi","Rendah","17 Oktober 2026",const Color(0xFFFFE9EF)),
];

class SplashPage extends StatelessWidget{
  const SplashPage({super.key});
  @override
  Widget build(BuildContext c)=>Scaffold(
    backgroundColor:navy,
    body:SafeArea(child:Stack(children:[
      Positioned(top:-40,left:-40,child:Container(width:140,height:140,decoration:const BoxDecoration(color:gold,shape:BoxShape.circle))),
      Positioned(bottom:-50,right:-50,child:Container(width:180,height:180,decoration:const BoxDecoration(color:gold,shape:BoxShape.circle))),
      Center(child:Column(mainAxisSize:MainAxisSize.min,children:[
        Container(width:95,height:95,decoration:BoxDecoration(color:gold,borderRadius:BorderRadius.circular(24)),
          child:const Icon(Icons.edit_note,size:60,color:navy)),
        const SizedBox(height:18),
        const Text("CatatanKu",style:TextStyle(color:Colors.white,fontSize:30,fontWeight:FontWeight.bold)),
        const SizedBox(height:8),
        const Text("Simpan ide, rencana, dan hal penting",style:TextStyle(color:Colors.white70)),
        const SizedBox(height:40),
        SizedBox(width:170,height:46,child:ElevatedButton(
          style:ElevatedButton.styleFrom(backgroundColor:gold,foregroundColor:navy),
          onPressed:()=>Navigator.pushReplacement(c,MaterialPageRoute(builder:(_)=>const LoginPage())),
          child:const Text("Mulai",style:TextStyle(fontWeight:FontWeight.bold)),
        ))
      ]))
    ])),
  );
}

class LoginPage extends StatelessWidget{
  const LoginPage({super.key});
  @override
  Widget build(BuildContext c)=>Scaffold(
    body:SafeArea(child:Padding(
      padding:const EdgeInsets.all(24),
      child:Column(children:[
        const SizedBox(height:35),
        Container(width:80,height:80,decoration:BoxDecoration(color:gold,borderRadius:BorderRadius.circular(20)),
          child:const Icon(Icons.edit_note,size:52,color:navy)),
        const SizedBox(height:15),
        const Text("CatatanKu",style:TextStyle(fontSize:28,fontWeight:FontWeight.bold,color:navy)),
        const Text("Masuk untuk melanjutkan"),
        const SizedBox(height:35),
        const TextField(decoration:InputDecoration(labelText:"Email",border:OutlineInputBorder())),
        const SizedBox(height:15),
        const TextField(obscureText:true,decoration:InputDecoration(labelText:"Password",border:OutlineInputBorder())),
        const SizedBox(height:20),
        SizedBox(width:double.infinity,height:48,child:ElevatedButton(
          style:ElevatedButton.styleFrom(backgroundColor:gold,foregroundColor:navy),
          onPressed:()=>Navigator.pushReplacement(c,MaterialPageRoute(builder:(_)=>const HomePage())),
          child:const Text("Masuk",style:TextStyle(fontWeight:FontWeight.bold)),
        )),
        const SizedBox(height:15),
        SizedBox(width:double.infinity,height:48,child:OutlinedButton.icon(
          icon:const Icon(Icons.g_mobiledata,color:navy,size:28),
          label:const Text("Masuk dengan Google",style:TextStyle(color:navy)),
          onPressed:()=>Navigator.pushReplacement(c,MaterialPageRoute(builder:(_)=>const HomePage())),
        )),
      ]),
    )),
  );
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override State<HomePage> createState()=>_HomePageState();
}
class _HomePageState extends State<HomePage>{
  String filter="Semua";
  @override
  Widget build(BuildContext c){
    final list=notes.where((n)=>filter=="Semua"||n.priority==filter||n.category==filter).toList();
    return Scaffold(
      appBar:AppBar(backgroundColor:navy,foregroundColor:Colors.white,title:const Text("Halo, Ahmadi 👋")),
      floatingActionButton:FloatingActionButton(backgroundColor:gold,foregroundColor:navy,
        onPressed:()async{
          final n=await Navigator.push<Note>(c,MaterialPageRoute(builder:(_)=>const AddPage()));
          if(n!=null)setState(()=>notes.insert(0,n));
        },child:const Icon(Icons.add)),
      bottomNavigationBar:NavigationBar(selectedIndex:0,destinations:const[
        NavigationDestination(icon:Icon(Icons.home),label:"Beranda"),
        NavigationDestination(icon:Icon(Icons.folder),label:"Arsip"),
        NavigationDestination(icon:Icon(Icons.person),label:"Profil"),
      ]),
      body:Padding(padding:const EdgeInsets.all(16),child:Column(children:[
        TextField(decoration:InputDecoration(prefixIcon:const Icon(Icons.search),hintText:"Cari catatan...",border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)))),
        const SizedBox(height:12),
        SingleChildScrollView(scrollDirection:Axis.horizontal,child:Row(children:["Semua","Penting","Pribadi","Kuliah"].map((e)=>Padding(
          padding:const EdgeInsets.only(right:8),
          child:ChoiceChip(label:Text(e),selected:filter==e,selectedColor:gold,onSelected:(_)=>setState(()=>filter=e)),
        )).toList())),
        const SizedBox(height:12),
        Expanded(child:ListView.builder(itemCount:list.length,itemBuilder:(c,i){
          final n=list[i];
          return Card(color:n.color,child:ListTile(
            leading:CircleAvatar(backgroundColor:gold,child:const Icon(Icons.note,color:navy)),
            title:Text(n.title,style:const TextStyle(fontWeight:FontWeight.bold)),
            subtitle:Text(n.date),
            trailing:const Icon(Icons.chevron_right),
            onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>DetailPage(n))),
          ));
        }))
      ])),
    );
  }
}

class AddPage extends StatefulWidget{
  const AddPage({super.key});
  @override State<AddPage> createState()=>_AddPageState();
}
class _AddPageState extends State<AddPage>{
  final t=TextEditingController(),b=TextEditingController();
  String cat="Pribadi",prio="Sedang";
  Color col=const Color(0xFFFFF3C4);
  @override
  Widget build(BuildContext c)=>Scaffold(
    appBar:AppBar(backgroundColor:navy,foregroundColor:Colors.white,title:const Text("Tambah Catatan")),
    body:ListView(padding:const EdgeInsets.all(20),children:[
      TextField(controller:t,decoration:const InputDecoration(labelText:"Judul",border:OutlineInputBorder())),
      const SizedBox(height:16),
      TextField(controller:b,maxLines:5,decoration:const InputDecoration(labelText:"Isi Catatan",border:OutlineInputBorder())),
      const SizedBox(height:16),
      DropdownButtonFormField(value:cat,items:["Pribadi","Kuliah","Kerja"].map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setState(()=>cat=v.toString())),
      const SizedBox(height:16),
      const Text("Warna"),
      const SizedBox(height:8),
      Row(children:[
        for(final c1 in [const Color(0xFFFFF3C4),const Color(0xFFE9F4FF),const Color(0xFFE8FFE8),const Color(0xFFFFE9EF)])
          GestureDetector(onTap:()=>setState(()=>col=c1),child:Container(margin:const EdgeInsets.only(right:10),width:34,height:34,decoration:BoxDecoration(color:c1,shape:BoxShape.circle,border:Border.all(color:col==c1?navy:Colors.transparent,width:3))))
      ]),
      const SizedBox(height:16),
      const Text("Prioritas"),
      const SizedBox(height:8),
      Row(children:["Rendah","Sedang","Tinggi"].map((e)=>Expanded(child:Padding(
        padding:const EdgeInsets.only(right:8),
        child:ChoiceChip(label:Center(child:Text(e)),selected:prio==e,selectedColor:gold,onSelected:(_)=>setState(()=>prio=e)),
      ))).toList()),
      const SizedBox(height:24),
      SizedBox(height:48,child:ElevatedButton(
        style:ElevatedButton.styleFrom(backgroundColor:navy,foregroundColor:Colors.white),
        onPressed:(){
          if(t.text.isEmpty||b.text.isEmpty)return;
          Navigator.pop(c,Note(t.text,b.text,cat,prio,"21 Oktober 2026",col));
        },
        child:const Text("Simpan"),
      ))
    ]),
  );
}

class DetailPage extends StatelessWidget{
  final Note n;
  const DetailPage(this.n,{super.key});
  @override
  Widget build(BuildContext c)=>Scaffold(
    appBar:AppBar(backgroundColor:navy,foregroundColor:Colors.white,title:const Text("Detail Catatan"),actions:[
      IconButton(icon:const Icon(Icons.edit),onPressed:(){}),
      IconButton(icon:const Icon(Icons.delete,color:Colors.redAccent),onPressed:(){notes.remove(n);Navigator.pop(c);})
    ]),
    body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Container(width:double.infinity,padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:n.color,borderRadius:BorderRadius.circular(16)),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(n.title,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold,color:navy)),
          const SizedBox(height:10),
          Chip(label:Text(n.priority),backgroundColor:gold),
        ])),
      const SizedBox(height:18),
      Row(children:[const Icon(Icons.calendar_today,size:18,color:navy),const SizedBox(width:8),Text(n.date)]),
      const SizedBox(height:18),
      Text(n.body,style:const TextStyle(fontSize:16,height:1.6)),
      const Spacer(),
      Text("Kategori: ${n.category}",style:const TextStyle(color:Colors.grey))
    ])),
  );
}
