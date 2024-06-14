import 'package:flutter/material.dart';
import 'package:flutter_example/core/models/result_model.dart';
import 'package:flutter_example/modules/dog/interfaces/dog_service_interface.dart';
import 'package:flutter_example/modules/dog/models/dog_model.dart';
import 'package:flutter_example/modules/dog/view/dogs_view.dart';
import 'package:flutter_example/modules/dog/widgets/failed_information_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class DogServiceMock extends Mock implements IDogService {}

void main() {
  late DogServiceMock dogServiceMock;
  late Widget widgetToTest;

  setUp(() {
    dogServiceMock = DogServiceMock();

    widgetToTest = MaterialApp(
      home: DogsView(
        dogService: dogServiceMock,
      ),
    );
  });

  group('List Dogs', () {
    final dogList = List.generate(
      30,
      (index) => DogModel(
        age: 1,
        breed: 'Poodle $index',
        description: 'Max is an intelligent and elegant Poodle.',
        name: 'Max',
      ),
    );

    testWidgets('Should list dogs when widget initialized', (widgetTester) async {
      when(
        () => dogServiceMock.getDogsPaginated(page: 1, pageSize: 10),
      ).thenAnswer((_) async {
        return Success(dogList);
      });

      await widgetTester.pumpWidget(widgetToTest);
      await widgetTester.pumpAndSettle();

      expect(find.byType(Card), findsExactly(dogList.length));
    });

    testWidgets('Should show error message when service fails', (widgetTester) async {
      when(
        () => dogServiceMock.getDogsPaginated(page: 1, pageSize: 10),
      ).thenAnswer((_) async {
        return Failure(Exception('Error'));
      });

      await widgetTester.pumpWidget(widgetToTest);
      await widgetTester.pumpAndSettle();

      expect(find.byType(FailedInformationWidget), findsOneWidget);
    });

    testWidgets('Should load more dogs when scrolling down', (widgetTester) async {
      when(
        () => dogServiceMock.getDogsPaginated(
          page: any(named: 'page'),
          pageSize: any(named: 'pageSize'),
        ),
      ).thenAnswer((_) async {
        return Success(dogList);
      });

      await widgetTester.pumpWidget(widgetToTest);
      await widgetTester.pumpAndSettle();

      final scrollable = find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first;

      await widgetTester.scrollUntilVisible(
        find.byType(Card).last,
        500,
        scrollable: scrollable,
      );

      await widgetTester.pumpAndSettle();

      expect(find.byType(Card), findsExactly(dogList.length * 2));
    });

    testWidgets('Should show an error view if a problem occurs while loading more', (widgetTester) async {
      when(
        () => dogServiceMock.getDogsPaginated(
          page: 1,
          pageSize: 10,
        ),
      ).thenAnswer((_) async {
        return Success(dogList);
      });

      when(
        () => dogServiceMock.getDogsPaginated(
          page: 2,
          pageSize: 10,
        ),
      ).thenAnswer((_) async {
        return Failure(Exception('Error'));
      });

      await widgetTester.pumpWidget(widgetToTest);
      await widgetTester.pumpAndSettle();

      final scrollable = find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first;

      await widgetTester.scrollUntilVisible(
        find.byType(Card).last,
        500,
        scrollable: scrollable,
      );

      await widgetTester.pumpAndSettle();

      expect(find.byType(FailedInformationWidget), findsOneWidget);
    });
  });

  group('Search Dogs', () {
    final initialDogList = List.generate(
      30,
      (index) => DogModel(
        age: 1,
        breed: 'Poodle $index',
        description: 'Max is an intelligent and elegant Poodle.',
        name: 'Max',
      ),
    );

    final searchedDogList = List.generate(
      15,
      (index) => DogModel(
        age: 1,
        breed: 'Golden retriever $index',
        description: 'Max is an intelligent and elegant Poodle.',
        name: 'Max',
      ),
    );

    testWidgets('Should search dogs when typing on search field', (widgetTester) async {
      when(
        () => dogServiceMock.getDogsPaginated(page: 1, pageSize: 10),
      ).thenAnswer((_) async {
        return Success(initialDogList);
      });

      when(
        () => dogServiceMock.searchDogs(
          page: 1,
          pageSize: 10,
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async {
        return Success(searchedDogList);
      });

      await widgetTester.pumpWidget(widgetToTest);
      await widgetTester.pumpAndSettle();

      final searchField = find.byType(TextField);

      await widgetTester.enterText(searchField, 'Max');
      await widgetTester.pumpAndSettle();

      expect(find.byType(Card), findsExactly(searchedDogList.length));
    });

    testWidgets('Should show error message when search service fails', (widgetTester) async {
      when(
        () => dogServiceMock.getDogsPaginated(page: 1, pageSize: 10),
      ).thenAnswer((_) async {
        return Success(initialDogList);
      });

      when(
        () => dogServiceMock.searchDogs(
          page: 1,
          pageSize: 10,
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async {
        return Failure(Exception('Error'));
      });

      await widgetTester.pumpWidget(widgetToTest);
      await widgetTester.pumpAndSettle();

      final searchField = find.byType(TextField);

      await widgetTester.enterText(searchField, 'Max');
      await widgetTester.pumpAndSettle();

      expect(find.byType(FailedInformationWidget), findsOneWidget);
    });

    testWidgets('Should return all dogs if search text is empty', (widgetTester) async {
      when(
        () => dogServiceMock.getDogsPaginated(page: 1, pageSize: 10),
      ).thenAnswer((_) async {
        return Success(initialDogList);
      });

      when(
        () => dogServiceMock.searchDogs(
          page: 1,
          pageSize: 10,
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async {
        return Success(searchedDogList);
      });

      await widgetTester.pumpWidget(widgetToTest);
      await widgetTester.pumpAndSettle();

      final searchField = find.byType(TextField);

      await widgetTester.enterText(searchField, 'Max');
      await widgetTester.pumpAndSettle();

      expect(find.byType(Card), findsExactly(searchedDogList.length));

      await widgetTester.enterText(searchField, '');
      await widgetTester.pumpAndSettle();

      expect(find.byType(Card), findsExactly(initialDogList.length));
    });

    testWidgets('Should search more when user scrolls', (widgetTester) async {
      when(
        () => dogServiceMock.getDogsPaginated(
          page: 1,
          pageSize: 10,
        ),
      ).thenAnswer((_) async {
        return Success(initialDogList);
      });

      when(
        () => dogServiceMock.searchDogs(
          page: 1,
          pageSize: 10,
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async {
        return Success(searchedDogList);
      });

      when(
        () => dogServiceMock.searchDogs(
          page: 2,
          pageSize: 10,
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async {
        return Success(searchedDogList);
      });

      await widgetTester.pumpWidget(widgetToTest);
      await widgetTester.pumpAndSettle();

      final searchField = find.byType(TextField);

      await widgetTester.enterText(searchField, 'Max');
      await widgetTester.pumpAndSettle();

      final scrollable = find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first;

      await widgetTester.scrollUntilVisible(
        find.byType(Card).last,
        500,
        scrollable: scrollable,
      );

      await widgetTester.pumpAndSettle();

      expect(find.byType(Card), findsExactly(searchedDogList.length * 2));
    });

    testWidgets('Should show error message if search more failes when user scrolls', (widgetTester) async {
      when(
        () => dogServiceMock.getDogsPaginated(
          page: 1,
          pageSize: 10,
        ),
      ).thenAnswer((_) async {
        return Success(initialDogList);
      });

      when(
        () => dogServiceMock.searchDogs(
          page: 1,
          pageSize: 10,
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async {
        return Success(searchedDogList);
      });

      when(
        () => dogServiceMock.searchDogs(
          page: 2,
          pageSize: 10,
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async {
        return Failure(Exception('Error'));
      });

      await widgetTester.pumpWidget(widgetToTest);
      await widgetTester.pumpAndSettle();

      final searchField = find.byType(TextField);

      await widgetTester.enterText(searchField, 'Max');
      await widgetTester.pumpAndSettle();

      final scrollable = find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first;

      await widgetTester.scrollUntilVisible(
        find.byType(Card).last,
        500,
        scrollable: scrollable,
      );

      await widgetTester.pumpAndSettle();

      expect(find.byType(FailedInformationWidget), findsOneWidget);
    });
  });

  group('Pull to Refresh', () {
    final initialDogList = List.generate(
      30,
      (index) => DogModel(
        age: 1,
        breed: 'Poodle $index',
        description: 'Max is an intelligent and elegant Poodle.',
        name: 'Max',
      ),
    );

    final searchedDogList = List.generate(
      15,
      (index) => DogModel(
        age: 1,
        breed: 'Golden retriever $index',
        description: 'Max is an intelligent and elegant Poodle.',
        name: 'Max',
      ),
    );

    setUp(() {
      when(
        () => dogServiceMock.getDogsPaginated(page: 1, pageSize: 10),
      ).thenAnswer((_) async {
        return Success(initialDogList);
      });

      when(
        () => dogServiceMock.searchDogs(
          page: 1,
          pageSize: 10,
          query: any(named: 'query'),
        ),
      ).thenAnswer((_) async {
        return Success(searchedDogList);
      });
    });

    testWidgets('Should refresh dogs when user pulls to refresh', (widgetTester) async {
      await widgetTester.pumpWidget(widgetToTest);
      await widgetTester.pumpAndSettle();

      final refreshIndicator = find.byType(RefreshIndicator);

      await widgetTester.drag(refreshIndicator, const Offset(0, 300));
      await widgetTester.pumpAndSettle();

      expect(find.byType(Card), findsExactly(initialDogList.length));
    });

    testWidgets('Should show error message if refresh fails', (widgetTester) async {
      when(
        () => dogServiceMock.getDogsPaginated(page: 1, pageSize: 10),
      ).thenAnswer((_) async {
        return Failure(Exception('Error'));
      });

      await widgetTester.pumpWidget(widgetToTest);
      await widgetTester.pumpAndSettle();

      final refreshIndicator = find.byType(RefreshIndicator);

      await widgetTester.drag(refreshIndicator, const Offset(0, 300));
      await widgetTester.pumpAndSettle();

      expect(find.byType(FailedInformationWidget), findsOneWidget);
    });
  });
}
