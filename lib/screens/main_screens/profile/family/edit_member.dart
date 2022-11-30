import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/models/patient_models/profile_models/families_model.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/shared/network/local/const_shared.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class EditMemberScreen extends StatefulWidget {
  const EditMemberScreen({Key? key, required this.familiesDataModel})
      : super(key: key);

  final FamiliesDataModel familiesDataModel;

  @override
  State<EditMemberScreen> createState() => _EditMemberScreenState();
}

class _EditMemberScreenState extends State<EditMemberScreen> {
  var userNameController = TextEditingController();
  var mobileController = TextEditingController();
  var nationalCodeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  final _focusNodes =
      Iterable<int>.generate(2).map((_) => FocusNode()).toList();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppEditMemberSuccessState) {
          if (state.successModel.status) {
            AppCubit.get(context).editMemberImage = null;
            Navigator.pop(context);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(state.successModel.message),
                );
              },
            );
          }
        } else if (state is AppEditMemberErrorState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(state.error.toString()),
              );
            },
          );
        }
        if (state is AppDeleteMemberSuccessState) {
          if (state.successModel.status) {
            Navigator.pop(context);
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(state.successModel.message),
                );
              },
            );
          }
        } else if (state is AppDeleteMemberErrorState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(state.error.toString()),
              );
            },
          );
        }
      },
      builder: (context, state) {
        var editMemberImage = AppCubit.get(context).editMemberImage;
        userNameController.text = widget.familiesDataModel.name;
        mobileController.text = widget.familiesDataModel.phone;
        nationalCodeController.text = widget.familiesDataModel.phoneCode;
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.txtEdit.tr(),
            centerTitle: false,
            appBarColor: greyExtraLightColor,
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 20.0),
            child: Form(
              key: formKey,
              child: KeyboardActions(
                tapOutsideBehavior: TapOutsideBehavior.translucentDismiss,
                config: KeyboardActionsConfig(
                  // Define ``defaultDoneWidget`` only once in the config
                  defaultDoneWidget: doneKeyboard(),
                  actions: _focusNodes
                      .map((focusNode) =>
                          KeyboardActionsItem(focusNode: focusNode))
                      .toList(),
                ),
                child: ListView(
                  children: [
                    Center(
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: editMemberImage == null
                                ? CachedNetworkImage(
                                    imageUrl: widget.familiesDataModel.profile,
                                    placeholder: (context, url) =>
                                        const SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Center(
                                          child: CircularProgressIndicator.adaptive()),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    width: 100,
                                    height: 100,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(83),
                                    child: Image.file(
                                      editMemberImage,
                                      height: 140,
                                      width: 140,
                                      fit: BoxFit.cover,
                                    )),
                          ),
                          InkWell(
                            onTap: () {
                              AppCubit.get(context).getEditMemberImage();
                            },
                            child: const CircleAvatar(
                              radius: 15.0,
                              backgroundColor: mainColor,
                              child: Icon(
                                Icons.edit,
                                color: whiteColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalMediumSpace,
                    textLabel(
                      title: LocaleKeys.txtFieldName.tr(),
                    ),
                    verticalSmallSpace,
                    DefaultFormField(
                      height: 90,
                      focusNode: _focusNodes[0],
                      controller: userNameController,
                      type: TextInputType.text,
                      label: LocaleKeys.txtFieldName.tr(),
                      validatedText: LocaleKeys.txtFieldName.tr(),
                      onTap: () {},
                    ),
                    verticalSmallSpace,
                    textLabel(
                      title: LocaleKeys.txtFieldMobile.tr(),
                    ),
                    verticalSmallSpace,
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GeneralNationalityCode(
                            controller: nationalCodeController,
                            canSelect: true,
                          ),
                        ),
                        horizontalMiniSpace,
                        Expanded(
                          flex: 3,
                          child: DefaultFormField(
                            height: 90,
                            focusNode: _focusNodes[1],
                            controller: mobileController,
                            type: TextInputType.phone,
                            validatedText: LocaleKeys.txtFieldMobile.tr(),
                            label: LocaleKeys.txtFieldMobile.tr(),
                          ),
                        ),
                      ],
                    ),
                    verticalSmallSpace,
                    ConditionalBuilder(
                      condition: state is! AppEditMemberLoadingState,
                      builder: (context) => GeneralButton(
                        title: LocaleKeys.BtnSaveChanges.tr(),
                        onPress: () {
                          if (formKey.currentState!.validate()) {
                            AppCubit.get(context).editMember(
                                memberId: widget.familiesDataModel.id,
                                name: userNameController.text,
                                phone: mobileController.text,
                                profile: editMemberImage == null
                                    ? ''
                                    : 'https://hq.orcav.com/assets/${Uri.file(editMemberImage.path).pathSegments.last}', phoneCode: nationalCodeController.text);
                          }
                        },
                      ),
                      fallback: (context) =>
                          const Center(child: CircularProgressIndicator.adaptive()),
                    ),
                    verticalSmallSpace,
                    ConditionalBuilder(
                      condition: state is! AppDeleteMemberLoadingState,
                      builder: (context) => GeneralButton(
                        title: LocaleKeys.BtnDelete.tr(),
                        btnBackgroundColor: redColor,
                        onPress: () {
                          showPopUp(
                            context,
                            Container(
                              height: 320,
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Column(
                                children: [
                                  verticalSmallSpace,
                                  Image.asset(
                                    'assets/images/warning-2.jpg',
                                    width: 50,
                                    height: 50,
                                  ),
                                  verticalMediumSpace,
                                  Text(
                                    LocaleKeys.txtDeleteMain.tr(),
                                    textAlign: TextAlign.center,
                                    style: titleStyle.copyWith(
                                      color: redColor,
                                    ),
                                  ),
                                  verticalMediumSpace,
                                  ConditionalBuilder(
                                    condition:
                                        state is! AppDeleteMemberLoadingState,
                                    builder: (context) => GeneralButton(
                                      radius: radius,
                                      btnBackgroundColor: redColor,
                                      title:
                                          LocaleKeys.txtUnderstandContinue.tr(),
                                      onPress: () {
                                        AppCubit.get(context).deleteMember(
                                            memberId:
                                                widget.familiesDataModel.id);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    fallback: (context) => const Center(
                                        child: CircularProgressIndicator.adaptive()),
                                  ),
                                  verticalSmallSpace,
                                  GeneralButton(
                                    radius: radius,
                                    btnBackgroundColor: greyExtraLightColor,
                                    txtColor: greyDarkColor,
                                    title: LocaleKeys.BtnCancel.tr(),
                                    onPress: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      fallback: (context) =>
                          const Center(child: CircularProgressIndicator.adaptive()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
