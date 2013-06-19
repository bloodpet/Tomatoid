/*
 *   Copyright 2013 Arthur Taborda <arthur.hvt@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents

ListView {
	property bool done //is a list of done tasks?

	id: taskList
	anchors.fill: parent
	clip: true //view itens only inside the container
	highlightFollowsCurrentItem: !tomatoid.timerRunning //when timer is running the highlight will not change

	Component.onCompleted: currentIndex = -1

	signal doTask(string taskIdentity)
	signal removeTask(string taskIdentity)
	signal startTask(string taskIdentity, string taskName)
	signal renameTask(string taskIdentity, string newName)

	highlight: PlasmaComponents.Highlight {
		opacity: 0
		Behavior on opacity {
			NumberAnimation {
				duration: 300
				easing.type: Easing.OutQuad
			}
		}
	}

	delegate: TaskItem {
		id: item
		identity: taskId
		name: taskName
		done: taskList.done
		donePomodoros: donePomos
		estimatedPomodoros: estimatedPomos

		onEntered: {
			taskList.currentIndex = index;

			if(!done || !tomatoid.timerRunning) { //dont enable highlight in completed task list when timer is running
				taskList.highlightItem.opacity = 1; //reenable opacity when entered an item
			}
		}
		onTaskDone: doTask(identity)
		onRemoved: removeTask(identity)
		onStarted: startTask(identity, taskName)
		onRename: renameTask(identity, name)
		onExited: {
			if(tomatoid.timerRunning) {
				taskList.highlightItem.opacity = done ? 0 : 1; //when timer is running dont turn off highlight in undone task list
				} else {
				taskList.highlightItem.opacity = 0; //when timer is not running turn off highlight when exited an item
			}
		}
	}
}
