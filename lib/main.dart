import 'package:ai_companion/api/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: MaterialApp(
        title: 'AI Companion',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Companion'),
        actions: [
          // Add refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<ChatProvider>(context, listen: false).fetchChat();
            },
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading chats...'),
                ],
              ),
            );
          }

          if (chatProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(chatProvider.error),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => chatProvider.fetchChat(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (chatProvider.chats.isEmpty) {
            return const Center(
              child: Text('No chats available'),
            );
          }
          
          return ListView.builder(
            itemCount: chatProvider.chats.length,
            itemBuilder: (context, index) {
              final chat = chatProvider.chats[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(chat.key.toString()),
                  subtitle: Text(chat.chats),
                ),
              );
            },
          );
        },
      ),
    );
  }
}