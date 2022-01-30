import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defultButton({
  double width = double.infinity,
  double height = 40.0,
  Color color = Colors.blue,
  Function function,
  @required String text,
}) =>
    Container(
      width: width,
      height: height,
      color: color,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          text.toLowerCase(),
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defultTextform({
  @required TextEditingController controller,
  @required TextInputType textInputType,
  @required Function validate,
  @required onSubmitted,
  @required Function onchanged,
  @required Function onTap,
  @required String labeltext,
  @required IconData prefix,
  IconData suffix,
  bool observedtext = false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: observedtext,
      onFieldSubmitted: (s) {
        onSubmitted();
      },
      onChanged: (c) {
        onchanged();
      },
      onTap: () {
        onTap();
      },
      validator: validate,
      decoration: InputDecoration(
        labelText: labeltext,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        prefixIcon: Icon(prefix),
        suffix: Icon(suffix),
      ),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${model['time']}',
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDate(status: 'done', id: model['id']);
              },
              icon: const Icon(Icons.check_box),
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDate(status: 'archive', id: model['id']);
              },
              icon: const Icon(Icons.archive),
              color: Colors.black45,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDate(
          id: model['id'],
        );
      },
    );

Widget tasksBuilder({
  @required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
        itemCount: tasks.length,
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
