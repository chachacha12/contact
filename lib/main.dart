import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(MaterialApp(
      home: MyApp()
  )
  ); //앱 시작해주세요~ / 괄호안에 앱 메인페이지 입력하면됨
}

zz;

//앱 메인페이지 만드는법임
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  //앱권한요청하는 함수 - 이 함수는 패키지만든사람이 정한 사용법일뿐..
  getPermission() async {
    var status = await Permission.contacts.status;  //연락처 권한줬는지 여부 판별
    if (status.isGranted) {   //전에 허락받았으면 여기 실행
      print('허락됨');
      var contacts = await ContactsService.getContacts();  //폰에 있는 연락처 다 가져오는 코드..근데 시간 좀오래걸리는 코드임. 그래서 await쓰는거 권장
      print(contacts);
      setState(() {
        name = contacts;  //name은 state이기때문에 변경하려면 setState()안에 써야함.
      });

    } else if (status.isDenied) { //허락안했으면 여기 실행
      print('거절됨');
      Permission.contacts.request();  //허락해달라고 팝업창 띄우는 코드임
    }

  }


  //initState안에 적은 코드는 위젯이 로드될때 한번 실행됨.즉 여기선 MyApp이 처음 실행될때 한번 실행됨
  @override
  void initState() {
    super.initState();
  }


  var total = 0;  //총 친구수
  var name = [];  //리스트임. 전화번호도 저장할거라 이 리스트안에 [이름, 전번] 이렇게 되어있는 리스트들을 다시 저장할거임.


  //친구 추가해주는 함수 생성
  addOne(inputData){
    setState(() {   //state를 수정하려면 이렇게 setState안에 써야함
      name.add( inputData  );
      total++;
    });
  }

  @override
  Widget build(BuildContext context) {        //위에서부터 여기까지 4줄은 그냥 원래 필요한부분임.

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context, builder: (context){
              return DialogUI( addOne: addOne  );
            });
          },
        ),

        appBar: AppBar(title: Text(total.toString()), actions: [
          IconButton(onPressed: (){ getPermission(); }, icon: Icon(Icons.contacts))
        ],),
        bottomNavigationBar: Bottomappbar(),
        body: ListView.builder(
          itemCount: name.length,
          itemBuilder: (c,i){

            // name.sort()       //그냥 string 오름차순 정렬임 (한글이면 가나다순 정렬됨)
            return ListTile(
              leading: Image.asset('assets/logo.png'),
              title: Text(name[i].givenName.toString()),
              trailing: TextButton(child: Text('삭제하기'), onPressed: (){
                setState(() {
                  name.removeAt(i);  //삭제해줌
                });
              }),
            ) ;
          },
        )
    );

  }
}

//다이얼로그 디자인
class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.addOne}) : super(key: key);
  final addOne;
  var inputData = TextEditingController();  //사용자가 입력한 값을 저장해주려고

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SizedBox(
          width: 400,
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Text('Contact',style: TextStyle(fontSize: 50, ), textAlign: TextAlign.start, ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextField( controller: inputData,),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(child: Text('취소'), onPressed: (){
                    Navigator. pop(context);    //현재 페이지 닫아주는 명령
                  })      ,
                  TextButton(child: Text('완료'), onPressed: (){
                    if( inputData.text.isNotEmpty) {
                      addOne(inputData.text);
                    }
                    Navigator. pop(context);    //현재 페이지 닫아주는 명령


                  })
                ],)
            ],
          ),
        )
    );
  }
}





class profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.account_circle_rounded),
          Text('홍길동')
        ],),
    );
  }
}

class  Bottomappbar extends StatelessWidget {
  const Bottomappbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(child:
    SizedBox(
      height: 80,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.phone),
            Icon(Icons.message),
            Icon(Icons.contact_page)
          ]
      ),
    ),
    );
  }
}



